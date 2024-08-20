self: { config, lib, pkgs, ... }:
let
  conf = config.my-emacs;
  emacs = pkgs.myEmacs;

  configFiles = import ./conf {
    inherit pkgs;
    font = with conf.font; {
      size = builtins.toString (size * 10);
    };
  };

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
in
{
  options.my-emacs = with lib; {
    enable = mkEnableOption "Enable my custom emacs";
    font = {
      size = mkOption { type = types.int; };
    };
  };

  config = lib.mkIf conf.enable {
    programs.emacs = {
      enable = true;
      package = emacs;
    };

    services.emacs = {
      client.enable = true;
      enable = true;
      package = emacs;
    };

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
      (iosevka.override {
        privateBuildPlan = {
          family = "Iosevka Aile";
          spacing = "quasi-proportional";
          serifs = "sans";
          noCvSs = true;
          exportGlyphNames = false;
        };
        set = "Aile";
      })
    ] ++ dirvishDeps ++ mermaidDeps;

    home.file."${config.xdg.configHome}/emacs/init.el" = {
      source = ./conf/init.el;
    };

    home.file."${config.xdg.configHome}/emacs/early-init.el" = {
      source = ./conf/early-init.el;
    };

    home.file."${config.xdg.configHome}/emacs/config.org" = {
      source = configFiles.config;
    };

    home.file."${config.xdg.configHome}/emacs/early.org" = {
      source = configFiles.early;
    };

    home.file."${config.xdg.configHome}/emacs/.local/cache/tree-sitter".source =
      "${(pkgs.emacsPackagesFor pkgs.emacs-unstable).treesit-grammars.with-all-grammars}/lib";
  };
}
