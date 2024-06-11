{ pkgs }: (pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages (
  epkgs: with epkgs; [
    ace-window
    catppuccin-theme
    consult
    embark
    evil
    ligature
    magit
    marginalia
    nix-mode
    orderless
    org-bullets
    org-roam
    tree-sitter
    tree-sitter-langs
    treesit-grammars.with-all-grammars
    vertico
    vterm
  ]
)
