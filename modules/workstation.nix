{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs;
    lib.optionals pkgs.stdenv.isLinux [
      sway
      waybar
      alacritty
      wofi
      foot
      grim
      slurp
      wl-clipboard
      swaylock
    ];

  services.displayManager.enable = lib.mkIf pkgs.stdenv.isLinux true;
  services.xserver.enable = lib.mkIf pkgs.stdenv.isLinux true;
}
