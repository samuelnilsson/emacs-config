{
  description = "My emacs config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, emacs-overlay, darwin }:
    let
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      overlayMyEmacs = final: prev: {
        myEmacs = import ./package.nix {
          pkgs = final;
        };
      };

      overlays = overlayMyEmacs;

      pkgsSystem = forAllSystems (system: import nixpkgs {
        system = system;
        overlays = [ overlayMyEmacs emacs-overlay.overlays.default ];
      });
    in
    {
      packages = forAllSystems (system: {
        default = pkgsSystem.${system}.myEmacs;
      });

      homeManagerModules.default = import ./home.nix self;

      darwinModules.default = import ./darwin.nix self;

      overlays.default = overlayMyEmacs;

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
