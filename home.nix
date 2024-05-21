self: { config, lib, pkgs, ... }:
{
  options = {
    my-emacs = with lib; {
      enable = mkEnableOption "Enable my custom emacs";
    };
  };

  config = lib.mkIf config.my-emacs.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.myEmacs;
    };

    services.emacs = {
      client.enable = true;
      enable = true;
      package = pkgs.myEmacs;
    };

    home.file."${config.xdg.configHome}/emacs" = {
      source = ./conf;
      recursive = true;
    };
  };
}
