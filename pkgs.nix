# This file is a Nix expression that exports a function.
# When imported, it expects an attribute set containing `pkgs` (usually Nixpkgs),
# and returns a Nix list of package derivations.
{pkgs}:
# `with pkgs;` brings every attribute of `pkgs` into the current scope.
# Instead of writing `pkgs.git`, you can just write `git`.
with pkgs;
# Nix lists are defined with square brackets and whitespace-separated elements.
  [
    # Each symbol here refers to a derivation provided by Nixpkgs.
    ansible # Configuration management tool
    argocd # GitOps continuous delivery
    asciiquarium # ASCII-art aquarium screensaver
    awscli # AWS command-line interface
    bat # `cat` clone with syntax highlighting
    bazel # Build system
    cargo # Rust package manager
    coreutils # Common GNU utilities (ls, cp, ...)
    delta # Pager for Git diffs with syntax highlighting
    delve # Go debugger
    docker # Container engine
    dust # Yet another `du`-alternative
    eza # Enhanced `ls` replacement
    fortune # Random quotes/fortunes
    fzf # Fuzzy finder
    gawk # Pattern scanning and processing language
    gh # GitHub CLI
    git # Version control
    gitleaks # Detect secrets in Git repos
    go # Go programming language
    golangci-lint # Aggregated Go linters
    htop # Interactive process viewer
    jq # JSON processor
    k3d # Kubernetes in Docker
    k9s # Interactive CLI for Kubernetes
    kind # Kubernetes in Docker for local clusters
    kubectl # Kubernetes CLI
    kubectx # Switch between Kubernetes contexts
    kubernetes-helm # Helm package manager
    kustomize # Kubernetes config customization
    lolcat # Rainbow colorizer
    neovim # Vim-fork editor
    nixpkgs-fmt # Formatter for Nix code
    nmap # Network exploration tool
    openbao # Secrets management
    opentofu # Infrastructure as code
    postgresql # Relational database
    pre-commit # Framework for pre-commit hooks
    procs # `ps` replacement
    prometheus # Monitoring system
    ripgrep # Fast text search
    rustc # Rust compiler
    rustfmt # Rust code formatter
    speedtest-cli # Internet speed test
    tailscale # Zero-config VPN
    terraform-docs # Docs generator for Terraform modules
    terragrunt # Terraform wrapper
    tflint # Terraform linter
    tig # Text-mode interface for Git
    tldr # Simplified man pages
    tree # Directory tree printer
    vcluster # Virtual Kubernetes clusters
    wget # Download files via HTTP
    yq # YAML processor
    zoxide # Intelligent `cd` replacement
  ]
