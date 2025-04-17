# Exports a function for shared configuration on both macOS and Linux.
# Notice the parameter pattern: `{ config, pkgs, lib, ... }` matches an attribute set.
{
  config,
  pkgs,
  lib,
  ...
}:
# `let ... in` introduces local bindings.
let
  # import our shared package-list function, passing down `pkgs`
  pkgList = import ../pkgs.nix {inherit pkgs;};
  # `inherit pkgs;` is shorthand for `pkgs = pkgs;` inside the argument set.
  aliasList = import ../aliases.nix;
in
  # `lib.mkMerge` takes a list of attribute sets and merges them.
  # Later sets can override earlier ones.
  lib.mkMerge [
    # Base settings
    {
      # Install packages at system/user level
      home.packages = pkgList;

      # Make shell aliases available globally
      home.shellAliases = aliasList;

      # Define environment variables: nested attribute sets
      home.sessionVariables = {
        LANG = "en_GB.UTF-8"; # set locale
      };

      # Program modules: each is an attribute set too.
      programs.zsh = {
        enable = true; # boolean literal
        #        enableFzfCompletion = true;
        syntaxHighlighting = {
          enable = true;
        };
        dotDir = ".config/zsh";
      };

      programs.tmux = {
        enable = true;
      };

      programs.vim.enable = true;
    }
  ]
