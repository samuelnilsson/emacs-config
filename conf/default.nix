{ font, pkgs, ... }:
{
  config = pkgs.substituteAll {
    src = ./config.org;
    fontSize = font.size;
  };
  early = pkgs.substituteAll {
    src = ./early.org;
    fontSize = font.size;
  };
}
