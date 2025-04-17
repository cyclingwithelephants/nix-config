{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/common.nix
    ../../modules/workstation.nix
    ../../modules/devtools.nix
  ];

  networking.hostName = "shallot";
  users.users.adam = {
    home = "/Users/adam";
  };
  programs.zsh.enable = true;
  system.stateVersion = 4;

  # Networking config: nested sets
  networking = {
    computerName = "shallot";
    hostName = "shallot";
    localHostName = "shallot";
  };

  # macOS GUI defaults via nix-darwin's `defaults`
  defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };
    NSGlobalDomain = {AppleShowAllFiles = true;};
    screencapture = {
      location = "~/Pictures/screenshots";
      type = "jpg";
    };
  };

  # Enable the Nix daemon service
  services.nix-daemon.enable = true;

  # Nix settings: attribute set under `nix` namespace
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = "nix-command flakes";
  };
}
