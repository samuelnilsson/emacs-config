{
  description = "My emacs config";

  inputs = {
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      emacs-overlay,
      pre-commit-hooks,
    }:
    let
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      overlays = (
        final: prev:
        prev.lib.composeManyExtensions [
          (final: prev: { myEmacs = (final.callPackage ./package.nix { pkgs = final; }); })
          emacs-overlay.overlays.package
        ] final prev
      );

      pkgsSystem = forAllSystems (
        system:
        import nixpkgs {
          system = system;
          overlays = [ overlays ];
        }
      );
    in
    {
      packages = forAllSystems (system: {
        default = pkgsSystem.${system}.myEmacs;
      });

      homeManagerModules.default = import ./home.nix self;

      overlays.default = overlays;

      pre-commit-check = forAllSystems (
        system:
        pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
          };
        }
      );

      checks = forAllSystems (system: {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
          };
        };
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsSystem.${system};
        in
        {
          default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs =
              with pkgs;
              [
                git
                nil
                nixfmt-rfc-style
              ]
              ++ self.checks.${system}.pre-commit-check.enabledPackages;
          };
        }
      );
    };
}
