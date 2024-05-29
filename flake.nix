{
  description = "My emacs config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, emacs-overlay }:
    let
      system = "x86_64-linux";

      overlayMyEmacs = prev: final: {
        myEmacs = import ./package.nix {
          pkgs = final;
        };
      };

      overlays = [ emacs-overlay.overlays.default overlayMyEmacs ];

      pkgs = import nixpkgs {
        system = system;
        overlays = overlays;
      };

    in
    {
      packages.${system}.default = pkgs.myEmacs;

      homeManagerModules.default = import ./home.nix self;

      overlays.default = overlays;

      apps.${system}.default =
        let
          config = import ./conf {
            inherit pkgs;
            font = {
              size = "120";
            };
          };

          start = pkgs.writeShellApplication {
            name = "start";
            runtimeInputs = [ pkgs.myEmacs ];
            text = ''
              EMACS_INIT_DIR=$(mktemp -d)
              cp ${config} "$EMACS_INIT_DIR/config.org"
              cp ${builtins.toString ./conf/init.el} "$EMACS_INIT_DIR"
              ${pkgs.myEmacs}/bin/emacs --init-directory "$EMACS_INIT_DIR"
            '';
          };
        in
        {
          type = "app";
          program = "${start}/bin/start";
        };

      devShell.${system} = pkgs.mkShell {
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
    };
}
