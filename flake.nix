{
  description = "MacOS x86";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [
            pkgs.ansible
            pkgs.argocd
            pkgs.asciiquarium
            pkgs.awscli
            pkgs.bat
            pkgs.bazel
            pkgs.cargo
            pkgs.coreutils
            pkgs.delve
            pkgs.docker
            pkgs.dust
            pkgs.eza
            pkgs.fortune
            pkgs.gawk
            pkgs.gh
            pkgs.git
            pkgs.gitleaks
            pkgs.go
            pkgs.golangci-lint
            pkgs.htop
            pkgs.jq
            pkgs.k3d
            pkgs.k9s
            pkgs.kind
            pkgs.kubectx
            pkgs.kubernetes-helm
            pkgs.kustomize
            pkgs.lolcat
            pkgs.neovim
            pkgs.nixpkgs-fmt
            pkgs.postgresql
            pkgs.pre-commit
            pkgs.procs
            pkgs.prometheus
            pkgs.ripgrep
            pkgs.rustc
            pkgs.rustfmt
            pkgs.speedtest-cli
            pkgs.terraform
            pkgs.terraform-docs
            pkgs.terragrunt
            pkgs.tflint
            pkgs.tig
            pkgs.tldr
            pkgs.tmux
            pkgs.tree
            pkgs.vault
            pkgs.vcluster
            pkgs.wget
            pkgs.youtube-dl
            pkgs.yq
            pkgs.zsh-autosuggestions
            pkgs.zsh-syntax-highlighting
        ];

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;

        nix = {
            package = pkgs.nix;
            # Necessary for using flakes on this system.
            settings.experimental-features = "nix-command flakes";
        };

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;

        # Set Git commit hash for darwin-version.
        system = {
            configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            stateVersion = 4;

            defaults = {

                dock = {
                    autohide                = true;
                    orientation             = "bottom";
                    show-process-indicators = false;
                    show-recents            = false;
                    static-only             = true;
                };

                finder = {
                    AppleShowAllExtensions         = true;
                    ShowPathbar                    = true;
                    FXEnableExtensionChangeWarning = false;
                    FXPreferredViewStyle           = "clmv";
                };

                screencapture = {
                    location = "~/Pictures/screenshots";
                    type     = "jpg";
                };

                screensaver.askForPasswordDelay = 10;
            };
        };

        # The platform the configuration will be used on.
        nixpkgs = {
            config.allowUnfree = true;
            hostPlatform       = "x86_64-darwin";
        };

        security.pam.enableSudoTouchIdAuth = true;

        networking = {
            hostName     = "garlic";
            computerName = "garlic";
        };

        # Use homebrew to install casks and Mac App Store apps
        homebrew = {
            enable = true;
            # onActivation.cleanup = "uninstall";

            casks = [
                "amethyst"
                "bitwarden"
                "calibre"
                "dash"
                "deluge"
                "discord"
                "firefox"
                "goland"
                "google-chrome"
                "iterm2"
                "logi-options-plus"
                "obsidian"
                "slack"
                "spotify"
                "visual-studio-code"
                "vlc"
                "wine-stable"
                "zed"
                "zoom"
            ];

         masApps = {
           "NAS Navigator2" = 450664466;
           "Trello"         = 1278508951;
         };
       };
    };
    in  {
            # Build darwin flake using:
            # $ darwin-rebuild build --flake .#garlic
            darwinConfigurations."garlic" = nix-darwin.lib.darwinSystem {
                modules = [ configuration ];
            };

            # Expose the package set, including overlays, for convenience.
            darwinPackages = self.darwinConfigurations."garlic".pkgs;
        };
    }
