{ font, pkgs, ... }:
pkgs.substituteAll {
  src = ./config.org;
  fontName = font.name;
  fontSize = font.size;
}
