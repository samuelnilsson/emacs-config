{ pkgs }: (pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages (
  epkgs: with epkgs; [
    vterm
    catppuccin-theme
    ligature
  ]
)
