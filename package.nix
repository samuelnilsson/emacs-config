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

  pkg = pkgs.symlinkJoin {
    name = "hello";
    paths = [ emacs ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/emacs \
        --prefix PATH : ${pkgs.lib.makeBinPath (mermaidDeps ++ dirvishDeps)}
    '';
  };

in
{
  pkg = pkg;
  treesit-grammars = treesit-grammars;
}

