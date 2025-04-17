{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/common.nix
    ../../modules/devtools.nix
    ./hardware-configuration.nix
  ];

  # Replace this with the actual hostname when instantiating
  networking.hostName = "template-server";

  # Define a placeholder user
  users.users.adam = {
    isNormalUser = true;
    home = "/home/adam";
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
  };

  # Optional: add a marker so you can reference this config by type later
  # environment.serverProfile = "base";
}
