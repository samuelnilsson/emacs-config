{ pkgs }:
let
  emacs29 = pkgs.emacsPackagesFor pkgs.emacs;
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
    (pkgs.stdenv.mkDerivation {
      name = "emms-taglib";
      src = pkgs.fetchurl {
        url = "ftp://ftp.gnu.org/gnu/emms/emms-6.00.tar.gz";
        sha256 = "sha256-awW1pv+BHQyx8BGbn+gxqH3WolKZQWglfNC3u8DbuNo=";
      };

      buildInputs = [ pkgs.taglib ];
      buildPhase = ''
        	LDFLAGS='-L${pkgs.lib.makeLibraryPath [ pkgs.zlib ]}' make emms-print-metadata
      '';
      installPhase = ''
        	mkdir -p $out/bin
                cp src/emms-print-metadata $out/bin
      '';
    })
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
      pass
      password-store
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

  conf =
    let
      config = import ./conf {
        pkgs = pkgs;
        font = {
          size = "120";
        };
      };
    in
    pkgs.stdenv.mkDerivation {
      pname = "emacs-conf";

      name = "emacs-conf";

      src = ./conf;

      buildInputs = [
        emacs
      ];

      buildPhase = ''
        cp ${config.config} config.org
        cp ${config.early} early.org
        emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "config.org" "config.el")'
        emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "early.org" "early.el")'
      '';

      installPhase = ''
        mkdir $out
        cp ./config.el $out
        cp ./early.el $out
        cp ./init.el $out
        cp ./early-init.el $out
      '';
    };

  pkg = pkgs.symlinkJoin {
    name = "emacs";
    paths = [ emacs ];
    buildInputs = [ pkgs.makeWrapper conf ];
    postBuild = ''
      wrapProgram $out/bin/emacs \
        --prefix PATH : ${pkgs.lib.makeBinPath (mermaidDeps ++ dirvishDeps ++ emmsDeps)} \
        --prefix TREESIT_LIB : ${treesit-grammars}/lib \
        --add-flags "--init-directory ${conf}"
    '';
  };
in
pkg
