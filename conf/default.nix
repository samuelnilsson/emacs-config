{ font, pkgs, ... }:
{
  config = pkgs.substituteAll {
    src = ./config.org;
    fontSize = font.size;
  };
}
