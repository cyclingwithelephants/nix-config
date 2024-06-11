# https://daiderd.com/nix-darwin/manual/index.html

{
  description = "MacOS x86";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment = {
            shellAliases = {
                g = "git";
                k  = "kubectl";
                kg = "kubectl get";
                kx = "kubectx";
                kwatch = "watch -n 1 kubectl";
                # formats ls as a vertical list, excluding extra information from ls -l
                # CLICOLOR_FORCE=1 forces ls colour to be displayed even through piping.
                # LC_COLLATE=cs_CZ.ISO8859-2 is a locale that is used to sort the alphabet in a case-insensitive way (i.e. aAbBcC rather than abcABC).
                # it does sort dotfiles after Z but we"re getting there.
                # similar to exa -1
                l = "CLICOLOR_FORCE=1 LC_COLLATE=cs_CZ.ISO8859-2 ls -lF  | awk \"{\$1=\$2=\$3=\$4=\$5=\$6=\$7=\$8=\"\"; if (NR!=1) print substr(\$0, 9)}\"";
                la = "CLICOLOR_FORCE=1 LC_COLLATE=cs_CZ.ISO8859-2 ls -lFA  | awk \"{\$1=\$2=\$3=\$4=\$5=\$6=\$7=\$8=\"\"; if (NR!=1) print substr(\$0, 9)}\"";
                please = "sudo";
                tf = "terraform";
                vim = "nvim";
            };
            systemPath = [];
            variables = {
                LANG = "en_GB.UTF-8";
            };
            systemPackages = [
                pkgs.ansible
                pkgs.argocd
                pkgs.asciiquarium
                pkgs.awscli
                pkgs.bat
                pkgs.bazel
                pkgs.cargo
                pkgs.coreutils
                pkgs.delta
                pkgs.delve
                pkgs.docker
                pkgs.dust
                pkgs.eza
                pkgs.fortune
                pkgs.fzf
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
                pkgs.kubectl
                pkgs.kubectx
                pkgs.kubernetes-helm
                pkgs.kustomize
                pkgs.lolcat
                pkgs.neovim
                pkgs.nixpkgs-fmt
                pkgs.nmap
                pkgs.postgresql
                pkgs.pre-commit
                pkgs.procs
                pkgs.prometheus
                pkgs.ripgrep
                pkgs.rustc
                pkgs.rustfmt
                pkgs.speedtest-cli
                pkgs.tailscale
                pkgs.terraform
                pkgs.terraform-docs
                pkgs.terragrunt
                pkgs.tflint
                pkgs.tig
                pkgs.tldr
                pkgs.tree
                pkgs.vault
                pkgs.vcluster
                pkgs.wget
                pkgs.youtube-dl
                pkgs.yq
                pkgs.zoxide
                # pkgs.zsh-autosuggestions
                # pkgs.zsh-syntax-highlighting
            ];
        };
        services = {
            # Auto upgrade nix package and the daemon service.
            nix-daemon.enable = true;
            # https://github.com/koekeishiya/skhd
            # skhd = {
            #     enable     = true;
            #     skhdConfig = "";
            # };
            # https://github.com/cmacrae/spacebar
            # spacebar = {
            #     enable      = true;
            #     config      = {};
            #     extraConfig = "";
            # };
            # https://github.com/Spotifyd/spotifyd
            # spotifyd = {
            #   enable   = true;
            #   settings = {};
            # };
            tailscale = {
                enable           = true;
                overrideLocalDns = true;
            };
            # https://github.com/koekeishiya/skhd
            # yabai = {
            #     enable                  = true;
            #     enableScriptingAddition = true;
            #     config = {
            #         focus_follows_mouse = "autoraise";
            #         mouse_follows_focus = "off";
            #         window_placement    = "second_child";
            #         window_opacity      = "off";
            #         top_padding         = 36;
            #         bottom_padding      = 10;
            #         left_padding        = 10;
            #         right_padding       = 10;
            #         window_gap          = 10;
            #     };
            #     extraConfig = "";
            # };
        };
        nix = {
            package = pkgs.nix;
            settings = {
                auto-optimise-store   = true;
                # Necessary for using flakes on this system
                experimental-features = "nix-command flakes";
            };
        };
        programs = {
            # Create /etc/zshrc that loads the nix-darwin environment
            zsh = {
                enable                   = true;
                enableFzfCompletion      = true;
                enableFzfGit             = true;
                enableFzfHistory         = true;
                enableSyntaxHighlighting = true;
                variables = {
                    ZDOTDIR = "\${HOME}/.config/zsh";
                };
            };
            tmux = {
                enable         = true;
                enableFzf      = true;
                enableMouse    = true;
                enableSensible = true;
                enableVim      = true;
                extraConfig    = "";
            };
            vim = {
                enable         = true;
                enableSensible = true;
                vimConfig      = "";
            };
        };
        # Set Git commit hash for darwin-version.
        system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            stateVersion = 4;

            defaults = {
                # Drops incoming requests via ICMP such as ping requests
                alf.stealthenabled = 1;
                dock = {
                    autohide                = true;
                    # do not rearrange spaces based on most recent use
                    mru-spaces              = false;
                    orientation             = "bottom";
                    # persistent-apps = [
                    #     "/Applications/Safari.app"
                    #     "/System/Applications/Utilities/Terminal.app"
                    # ];
                    persistent-others       = [];
                    show-process-indicators = false;
                    show-recents            = false;
                    static-only             = true;
                };
                finder = {
                    AppleShowAllExtensions         = true;
                    ShowPathbar                    = true;
                    FXEnableExtensionChangeWarning = false;
                    FXPreferredViewStyle           = "clmv";
                    ShowStatusBar                  = true;
                    _FXShowPosixPathInTitle        = true;
                };
                NSGlobalDomain = {
                    # enable dark mode all the time
                    # AppleInterfaceStyle = "dark";
                    # swap between light and dark depending on the time
                    AppleInterfaceStyleSwitchesAutomatically = true ;
                    AppleShowAllExtensions = true;
                    # show hidden files in finder
                    AppleShowAllFiles      = true;
                    InitialKeyRepeat       = 15;
                    KeyRepeat              = 2;
                    NSNavPanelExpandedStateForSaveMode = true;
                    # enable moving window by holding anywhere on it like on Linux
                    NSWindowShouldDragOnGesture = true;
                    # enable the expanded print menu when printing
                    PMPrintingExpandedStateForPrint = true;
                    # enables tap-to-click on trackpad
                    "com.apple.mouse.tapBehavior" = 1;
                };
                menuExtraClock = {
                    Show24Hour     = true;
                    ShowAMPM       = false;
                    # always show the date
                    ShowDate       = 1;
                    ShowDayOfMonth = true;
                    ShowDayOfWeek  = true;
                };
                screencapture = {
                    location = "~/Pictures/screenshots";
                    type     = "jpg";
                };
                screensaver.askForPasswordDelay                 = 10;
                SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
                trackpad = {
                    Clicking                = true;
                    TrackpadThreeFingerDrag = false;
                };
                # use scroll gesture with the Ctrl (^) modifier key to zoom
                universalaccess.closeViewScrollWheelToggle = true;
                # Text to be shown on the login window
                loginwindow.LoginwindowText = "";
            };
            # Whether to enable the startup chime.
            # By default, this option does not affect your system configuration in any way.
            # However, after it has been set once, unsetting it will not return to the old behavior.
            # It will allow the setting to be controlled in System Settings, though.
            startup.chime = false;
        };
        # The platform the configuration will be used on.
        nixpkgs = {
            config.allowUnfree = true;
            hostPlatform       = "x86_64-darwin";
        };
        security.pam.enableSudoTouchIdAuth = true;
        networking = {
            # dns          = [
            #     "1.1.1.1" # cloudflare
            #     "1.0.0.1" # cloudflare
            # ];
            computerName  = "garlic";
            hostName      = "garlic";
            localHostName = "garlic";
        };
        # Use homebrew to install casks and Mac App Store apps because macOS GUI apps aren"t in nix
        homebrew = {
            enable = true;
            onActivation = {
                cleanup    = "uninstall";
                autoUpdate = true;
                upgrade    = true;
            };
            taps            = ["caskroom/cask"];
            caskArgs.appdir = "~/Applications";
            casks = [
                "amethyst"
                "bitwarden"
                "calibre"
                "dash"
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
                "wechat"
                "whatsapp"
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
