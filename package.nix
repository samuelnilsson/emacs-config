{ pkgs }: (pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages (
  epkgs: with epkgs; [
    catppuccin-theme
    embark
    evil
    ligature
    marginalia
    orderless
    org-roam
    vertico
    vterm
    org-bullets
    tree-sitter
    tree-sitter-langs
    treesit-grammars.with-all-grammars
    nix-mode
  ]
)
