self: { config, lib, pkgs, ... }:
let
  conf = config.my-emacs;
  emacs = pkgs.myEmacs;

  configFile = import ./conf {
    inherit pkgs;
    font = with conf.font; {
      name = name;
      size = builtins.toString (size * 10);
    };
  };

in
{
  options.my-emacs = with lib; {
    enable = mkEnableOption "Enable my custom emacs";
    font = {
      name = mkOption { type = types.str; };
      size = mkOption { type = types.int; };
    };
  };

  config = lib.mkIf conf.enable {
    programs.emacs = {
      enable = true;
      package = emacs;
    };

    services.emacs = {
      client.enable = true;
      enable = true;
      package = emacs;
    };

    home.file."${config.xdg.configHome}/emacs/init.el" = {
      source = ./conf/init.el;
    };

    home.file."${config.xdg.configHome}/emacs/config.org" = {
      source = configFile;
    };
  };
}
