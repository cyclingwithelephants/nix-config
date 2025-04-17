# File: aliases.nix
# This Nix expression exports an attribute set mapping alias names to commands.
# Nix attribute sets use `{ key = value; ... }` syntax.
{
  g = "git"; # `g` alias for `git`
  k = "kubectl"; # `k` alias for `kubectl`
  kg = "kubectl get"; # `kg` to quickly list resources
  kx = "kubectx"; # `kx` to switch contexts
  kwatch = "watch -n 1 kubectl"; # `kwatch` to watch resource changes

  # Complex shell commands must be quoted as strings.
  l = "CLICOLOR_FORCE=1 LC_COLLATE=cs_CZ.ISO8859-2 ls -lF | awk '{\$1=\$2=\$3=\$4=\$5=\$6=\$7=\$8=\"\"; if(NR!=1) print substr(\$0,9)}'";
  la = "CLICOLOR_FORCE=1 LC_COLLATE=cs_CZ.ISO8859-2 ls -lFA | awk '{\$1=\$2=\$3=\$4=\$5=\$6=\$7=\$8=\"\"; if(NR!=1) print substr(\$0,9)}'";

  please = "sudo"; # politely ask for root
  tf = "terraform"; # Terraform shortcut
  vim = "nvim"; # use Neovim instead of Vim
}
