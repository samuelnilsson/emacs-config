{ self, ... }@inputs:
{ options, config, pkgs, ... }:
{
  options = {
    my-emacs = with lib; {
      enable = mkEnableOption "Enable my custom emacs";
    };
  };

  config = lib.mkIf config.my-emacs.enable {
    nixpkgs.overlays = [ (import self.inputs.emacs-overlay) ];

    programs.emacs = {
      enable = true;
      package = pkgs.emacs-unstable;
    };

    services.emacs = {
      client.enable = true;
      enable = true;
      package = pkgs.emacs-unstable;
    };

    home.file."${config.xdg.configHome}/emacs" = {
      source = ./conf;
      recursive = true;
    };
  };
}
