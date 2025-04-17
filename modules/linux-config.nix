# Linux-specific Home Manager layer, merging on common.nix.
{
  config,
  pkgs,
  lib,
  ...
}: let
  common = import ./common.nix {inherit config pkgs lib;};
in
  lib.mkMerge [
    common

    # Linux-only overrides
    {
      home = {
        username = "adam"; # string for user name
        homeDirectory = "/home/adam"; # path string
        stateVersion = "23.11"; # used by Home Manager
      };
    }
  ]
