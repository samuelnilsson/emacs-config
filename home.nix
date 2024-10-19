self: { config, lib, pkgs, ... }:
let
  conf = config.my-emacs;
  emacs = pkgs.myEmacs;
in
{
  options.my-emacs = with lib; {
    enable = mkEnableOption "Enable my custom emacs";
    isDarwin = mkOption { type = boolean; default = false; };
    font = {
      size = mkOption { type = types.int; };
    };
  };

  config = lib.mkIf conf.enable (
    lib.mkMerge [
      (lib.mkIf (!conf.isDarwin) {
        services.emacs = {
          client.enable = true;
          enable = true;
          package = emacs;
        };
      }
      )
      {
        programs.emacs = {
          enable = true;
          package = emacs;
        };

        home.packages = import ./font.nix pkgs;
      }
    ]);
}
