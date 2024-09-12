{ pkgs }:
let
  emacs29 = pkgs.emacsPackagesFor pkgs.emacs-unstable;
  treesit-grammars = emacs29.treesit-grammars.with-all-grammars;

  dirvishDeps = with pkgs; [
    epub-thumbnailer
    fd
    ffmpegthumbnailer
    gnutar
    imagemagick
    mediainfo
    unzip
  ];

  mermaidDeps = with pkgs; [
    mermaid-cli
  ];

  prependPkgsToPath = packages: "PATH=${pkgs.lib.strings.concatMapStrings (x: "${x}/bin:") packages}:$PATH";

  emacs = emacs29.emacsWithPackages (
    epkgs: with epkgs; [
      ace-window
      catppuccin-theme
      company
      consult
      consult-flycheck
      dirvish
      doom-modeline
      embark
      embark-consult
      envrc
      evil
      evil-collection
      flycheck
      general
      ligature
      lsp-mode
      lsp-ui
      magit
      marginalia
      mermaid-mode
      nerd-icons
      nerd-icons-completion
      nerd-icons-dired
      nerd-icons-ibuffer
      nix-ts-mode
      no-littering
      ob-mermaid
      orderless
      org-bullets
      org-roam
      pdf-tools
      treesit-grammars
      treesit-auto
      vertico
      vterm
      which-key
    ]
  );
in
{
  pkg = pkgs.writeShellApplication {
    name = "emacs";
    runtimeInputs = [ emacs ];
    text = ''
      ${prependPkgsToPath (mermaidDeps ++ dirvishDeps)}
      ${emacs}/bin/emacs "$@"
    '';
  };
  treesit-grammars = treesit-grammars;
}
