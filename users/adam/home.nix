{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "adam";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/adam"
    else "/home/adam";
  home.stateVersion = "23.11";

  # Make shell aliases available globally
  home.shellAliases = {
    g = "git";
    k = "kubectl";
    kg = "kubectl get";
    kx = "kubectx";
    kn = "kubens";
    kwatch = "watch -n 1 kubectl"; # `kwatch` to watch resource changes

    # Complex shell commands must be quoted as strings.
    l = "CLICOLOR_FORCE=1 LC_COLLATE=cs_CZ.ISO8859-2 ls -lF | awk '{\$1=\$2=\$3=\$4=\$5=\$6=\$7=\$8=\"\"; if(NR!=1) print substr(\$0,9)}'";
    la = "CLICOLOR_FORCE=1 LC_COLLATE=cs_CZ.ISO8859-2 ls -lFA | awk '{\$1=\$2=\$3=\$4=\$5=\$6=\$7=\$8=\"\"; if(NR!=1) print substr(\$0,9)}'";

    please = "sudo"; # politely ask for root
    tf = "tofu"; # Terraform shortcut
    vim = "nvim"; # use Neovim instead of Vim
  };

  home.packages = with pkgs; [git zsh];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    dotdir = ".config/zsh/";
  };

  programs.git = {
    enable = true;
    userName = "Adam Rummer";
    userEmail = "adamrummer@gmail.com";
  };

  # Placeholder for secrets: to use later with sops-nix or agenix
  # home.file.".ssh/id_rsa".source = ./secrets/id_rsa; # secure this with age
}
