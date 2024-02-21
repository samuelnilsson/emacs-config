{
  description = "My emacs config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @ { self, nixpkgs, emacs-overlay }: {
    homeManagerModules = import ./emacs.nix inputs;
  };
}
