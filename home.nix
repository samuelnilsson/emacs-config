self: { config, lib, pkgs, ... }:
let
  emacs = pkgs.myEmacs;
in
{
  options = {
    my-emacs = with lib; {
      enable = mkEnableOption "Enable my custom emacs";
    };
  };

  config = lib.mkIf config.my-emacs.enable {
    programs.emacs = {
      enable = true;
      package = emacs;
    };

    services.emacs = {
      client.enable = true;
      enable = true;
      package = emacs;
    };

    home.file."${config.xdg.configHome}/emacs" = {
      source = ./conf;
      recursive = true;
    };
  };
}
