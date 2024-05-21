{ pkgs }: (pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages (
  epkgs: [ epkgs.vterm ]
)
