self: { config, lib, pkgs, ... }:
let
  conf = config.my-emacs;
  emacs = pkgs.myEmacs;
in
{
  options.my-emacs = with lib; {
    enable = mkEnableOption "Enable my custom emacs";
    font = {
      size = mkOption { type = types.int; };
    };
  };

  config = lib.mkIf conf.enable {
    services.emacs = {
      enable = true;
      package = emacs;
    };

    fonts.packages = with pkgs; [
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
    ];
  };
}
