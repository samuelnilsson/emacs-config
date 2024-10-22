self: { config, lib, pkgs, ... }:
let
  conf = config.my-emacs;
  emacs = pkgs.myEmacs;
  inherit (pkgs) stdenv;
in
{
  options.my-emacs = with lib; {
    enable = mkEnableOption "Enable my custom emacs";
    font = {
      size = mkOption { type = types.int; };
    };
  };

  config = lib.mkIf conf.enable (
    lib.mkMerge [
      (lib.mkIf stdenv.isDarwin {
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
