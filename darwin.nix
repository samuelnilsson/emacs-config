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
    environment.systemPackages = [ emacs ];

    fonts.packages = import ./font.nix pkgs;
  };
}
