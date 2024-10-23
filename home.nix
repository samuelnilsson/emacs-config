self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  conf = config.my-emacs;
  emacs = pkgs.myEmacs.override { font = conf.font; };
  inherit (pkgs) stdenv;
in
{
  options.my-emacs = with lib; {
    enable = mkEnableOption "Enable my custom emacs";
    font = {
      size = mkOption {
        type = types.int;
        default = if stdenv.isDarwin then 160 else 120;
      };
    };
  };

  config = lib.mkIf conf.enable {
    programs.emacs = {
      enable = true;
      package = emacs;
    };

    home.packages = import ./font.nix pkgs;
  };
}
