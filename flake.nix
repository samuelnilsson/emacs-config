{
  description = "My emacs config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, emacs-overlay }:
    let
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      overlays = (final: prev: prev.lib.composeManyExtensions [
        (final: prev: {
          myEmacs = import ./package.nix {
            pkgs = final;
          };
        })
        emacs-overlay.overlays.package
      ]
        final
        prev);

      pkgsSystem = forAllSystems (system: import nixpkgs {
        system = system;
        overlays = [ overlays ];
      });
    in
    {
      packages = forAllSystems (system: {
        default = pkgsSystem.${system}.myEmacs;
      });

      homeManagerModules.default = import ./home.nix self;

      overlays.default = overlays;

      devShells = forAllSystems (system:
        let
          pkgs = pkgsSystem.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              nil
              nixpkgs-fmt
              pre-commit
            ];
            shellHook = ''
              pre-commit install
            '';
          };
        });
    };
}
