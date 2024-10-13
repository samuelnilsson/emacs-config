self: { config, lib, pkgs, ... }:
with pkgs; [
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
]
