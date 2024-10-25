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
    jira = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      url = mkOption {
        type = types.string;
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
