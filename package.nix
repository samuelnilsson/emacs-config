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

  emmsDeps = with pkgs; [
    mpv
  ];

  emacs = emacs29.emacsWithPackages (
    epkgs: with epkgs; [
      ace-window
      cape
      catppuccin-theme
      corfu
      consult
      consult-flycheck
      dirvish
      doom-modeline
      embark
      embark-consult
      emms
      envrc
      evil
      evil-collection
      flycheck
      general
      ligature
      magit
      marginalia
      mermaid-mode
      nerd-icons
      nerd-icons-completion
      nerd-icons-corfu
      nerd-icons-dired
      nerd-icons-ibuffer
      nix-ts-mode
      no-littering
      ob-mermaid
      orderless
      org-modern
      org-roam
      pdf-tools
      protobuf-ts-mode
      treesit-auto
      verb
      vertico
      vterm
      which-key
      yasnippet
      yasnippet-snippets
    ]
  );

  pkg = pkgs.symlinkJoin {
    name = "hello";
    paths = [ emacs ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
            wrapProgram $out/bin/emacs \
              --prefix PATH : ${pkgs.lib.makeBinPath (mermaidDeps ++ dirvishDeps ++ emmsDeps)} \
      	--prefix TREESIT_LIB : ${treesit-grammars}/lib
    '';
  };
in
pkg
