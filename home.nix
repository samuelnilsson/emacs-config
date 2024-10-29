self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  conf = config.my-emacs;
  emacs = pkgs.myEmacs.override {
    font = conf.font;
    musicDir = conf.musicDir;
    jira = conf.jira;
  };
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
    musicDir = mkOption {
      type = types.str;
      default = if stdenv.isDarwin then "/Volumes/music" else "/mnt/music";
    };
    jira = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      url = mkOption {
        type = types.str;
        default = "";
      };
      user = mkOption {
        type = types.str;
        default = "";
      };
      extra-conf = mkOption {
        type = types.str;
        default = "";
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
