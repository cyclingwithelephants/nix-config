# macOS-specific layer: imports common.nix and merges extra settings.
{
  config,
  pkgs,
  lib,
  ...
}:
# Bring in shared settings via `import` with same params
let
  common = import ./common.nix {inherit config pkgs lib;};
in
  # Merge common + macOS overrides
  lib.mkMerge [
    common # everything from common

    # macOS-specific
    {
      # Enable the Nix daemon service
      services.nix-daemon.enable = true;

      # Nix settings: attribute set under `nix` namespace
      nix.settings = {
        auto-optimise-store = true;
        experimental-features = "nix-command flakes";
      };

      # Tailscale system service
      services.tailscale = {
        enable = true;
        overrideLocalDns = true;
      };

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

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

      # GUI apps via Homebrew Casks and MAS
      homebrew = {
        enable = true;
        taps = ["caskroom/cask"]; # Nix list inside Nix list
        caskArgs.appdir = "~/Applications"; # string value
        casks = ["firefox" "iterm2" "vscode" "slack" "zoom"];
        masApps = {
          "NAS Navigator2" = 450664466; # integer literal
          "Trello" = 1278508951;
        };
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "uninstall";
        };
      };
    }
  ]
