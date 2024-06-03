{ pkgs }: (pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages (
  epkgs: with epkgs; [
    catppuccin-theme
    evil
    ligature
    marginalia
    orderless
    org-roam
    vertico
    vterm
  ]
)
