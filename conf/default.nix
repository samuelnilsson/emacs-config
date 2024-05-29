{ font, pkgs, ... }:
pkgs.substituteAll {
  src = ./config.org;
  fontSize = font.size;
}
