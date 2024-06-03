self: { config, lib, pkgs, ... }:
let
  conf = config.my-emacs;
  emacs = pkgs.myEmacs;

  configFile = import ./conf {
    inherit pkgs;
    font = with conf.font; {
      size = builtins.toString (size * 10);
    };
  };

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

    home.packages = [
      (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
      (pkgs.iosevka.override {
        privateBuildPlan = {
          family = "Iosevka Aile";
          spacing = "quasi-proportional";
          serifs = "sans";
          noCvSs = true;
          exportGlyphNames = false;
        };
        set = "Aile";
      })
    ];

    home.file."${config.xdg.configHome}/emacs/init.el" = {
      source = ./conf/init.el;
    };

    home.file."${config.xdg.configHome}/emacs/early-init.el" = {
      source = ./conf/early-init.el;
    };

    home.file."${config.xdg.configHome}/emacs/config.org" = {
      source = configFile;
    };
  };
}
