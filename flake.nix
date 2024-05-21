{
  description = "My emacs config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, emacs-overlay }:
  let
    overlayMyEmacs = prev: final: {
      myEmacs = import ./package.nix {
        pkgs = final;
      };
    };

    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ emacs-overlay.overlays.default overlayMyEmacs ];
    };

  in {
    packages.x86_64-linux.default = pkgs.myEmacs;

    homeManagerModules.default = import ./home.nix self;

    overlays.default = [ emacs-overlay.overlays.default overlayMyEmacs ];

    apps.x86_64-linux.default =  
      let
      serv = pkgs.writeShellApplication {
        name = "start";
        runtimeInputs = [pkgs.myEmacs];
        text = ''
          EMACS_INIT_DIR=$(mktemp -d)
          cp ${builtins.toString ./conf}/* "$EMACS_INIT_DIR"
          ${pkgs.myEmacs}/bin/emacs --init-directory "$EMACS_INIT_DIR"
        '';
      };
    in {
      type = "app";
      program = "${serv}/bin/start";
    };
  };
}
