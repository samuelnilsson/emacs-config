pkgs: with pkgs; [
  nerd-fonts.iosevka
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
