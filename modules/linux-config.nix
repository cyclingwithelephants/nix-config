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

    {
      home = {
        username = "adam"; # string for user name
        homeDirectory = "/home/adam"; # path string
        stateVersion = "23.11"; # used by Home Manager
      };
      # Sway window manager configuration for user "adam"
      wayland.windowManager.sway = {
        enable = true;
        package = pkgs.sway; # Use Sway from Nix packages (ensures correct version)

        config = {
          # **Input configuration for Apple keyboard**
          input = {
            # Apply to all keyboard devices (or specify identifier if needed via `input "<identifier>"`)
            "type:keyboard" = {
              xkb_layout = "gb"; # Keyboard layout (use "gb" for UK, etc., as appropriate)
              xkb_model = "apple";  # Use Apple keyboard model (uncomment if needed for Apple-specific keys)
#              xkb_options = "caps:escape"; # Example: make Caps Lock an Escape (common tweak, optional)

              # You can add more XKB options here. For instance:
              # "ctrl:swap_lwin_lctl,ctrl:swap_rwin_rctl" would swap Command (Win) and Ctrl if desired.
              # By default, we assume the Apple Command key is mapped as the Super (Mod4) key.
              # The above options are not set because we want Command to remain Mod4 (primary modifier) and Control as Control.
              # If you ever needed to treat the right Command as Control, you could add an option like "ctrl:swap_rwin_rctl".
            };
          };

          # **Define Command (⌘) as the primary modifier key**
          modifier = "Mod4"; # Mod4 corresponds to the Super/Windows key, which is Command on Apple keyboards

          # **Keybindings (mimicking macOS behavior with Command as primary key)**
          keybindings = let
            # Convenience variables for modifiers
            mod = "Mod4"; # Command (Super)
            shift = "Shift"; # Shift
            ctrl = "Ctrl"; # Control
          in {
            # -- Application Launchers --
            "${mod}+Return" = ''exec ${pkgs.foot}/bin/foot'';
            # ^ Launch terminal (Foot) with Cmd+Enter. Foot is chosen for Wayland; it supports copy/paste via special keysyms
            #   If Foot didn't meet our needs, alternatives like Alacritty or Kitty could be used (configurable for custom shortcuts).

            "${mod}+Space" = ''exec ${pkgs.wofi}/bin/wofi --show=drun --prompt="Launch: "'';
            # ^ Open application launcher (Wofi) with Cmd+Space, similar to macOS Spotlight.
            #   --show=drun uses desktop entries for apps. The prompt text is set to "Launch:" for clarity.

            "${mod}+Tab" = ''exec ${pkgs.wofi}/bin/wofi --show=window --prompt="Windows: "'';
            # ^ Show window switcher (akin to Cmd+Tab on macOS). This opens a Wofi menu of open windows
            #   You can then search or arrow-key through windows; selecting one focuses it.
            #   (Note: This isn't a live Alt-Tab cycler, but it provides similar functionality in a menu.)

            # -- Clipboard Shortcuts (Copy, Paste, Cut) --
            "${mod}+c" = "exec ${pkgs.wtype}/bin/wtype -P XF86Copy"; # Cmd+C to Copy
            "${mod}+v" = "exec ${pkgs.wtype}/bin/wtype -P XF86Paste"; # Cmd+V to Paste
            "${mod}+x" = "exec ${pkgs.wtype}/bin/wtype -P XF86Cut"; # Cmd+X to Cut
            # ^ Using wtype to simulate XF86Copy/Paste/Cut key events means these work universally in GUI apps and terminals
            #   Foot terminal, for example, natively recognizes XF86Copy/XF86Paste as copy/paste shortcuts
            #   so Cmd+C/V/X will copy, paste, cut in the terminal just like in GUI applications, matching macOS behavior.
            #   (Most applications/toolkits either handle these special keysyms or can be configured to.)
            #   This avoids the Ctrl+Shift vs Ctrl key differences for terminals vs other apps.

            # -- Lock Screen --
            "${mod}+${ctrl}+q" = ''exec ${pkgs.swaylock}/bin/swaylock -f -c 000000'';
            # ^ Cmd+Ctrl+Q to lock the screen (like macOS). This uses swaylock to lock with a simple black background (-c 000000).
            #   (Ensure you have swaylock installed and consider configuring it for password prompt style if desired.)

            # -- Screenshots (Full and Region, to file or clipboard) --
            "${mod}+${shift}+3" = ''exec sh -c 'grim "~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png'"'';
            "${mod}+${ctrl}+${shift}+3" = ''exec sh -c 'grim - | ${pkgs.wl-clipboard}/bin/wl-copy' '';
            # ^ Cmd+Shift+3: Capture entire screen to a timestamped file in ~/Pictures (mimicking macOS Cmd+Shift+3).
            #   Cmd+Ctrl+Shift+3: Capture entire screen and copy to clipboard (mimics adding Control on macOS to copy instead of save).

            "${mod}+${shift}+4" = ''exec sh -c 'grim -g \"$(slurp)\" "~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png\"' '';
            "${mod}+${ctrl}+${shift}+4" = ''exec sh -c 'grim -g \"$(slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy' '';
            # ^ Cmd+Shift+4: Screenshot a selected region (using slurp to select) to file (like macOS Cmd+Shift+4).
            #   Cmd+Ctrl+Shift+4: Screenshot a selected region and copy to clipboard.
            #   We use `grim -g "$(slurp)"` to grab the selection geometry from slurp
            #   The output is either saved to ~/Pictures or piped to wl-copy for clipboard.
            #   (You can change the save directory or filename pattern as needed. "~" will be expanded by the shell.)

            # -- Workspace Management --
            "${mod}+1" = "workspace 1";
            "${mod}+2" = "workspace 2";
            "${mod}+3" = "workspace 3";
            "${mod}+4" = "workspace 4";
            "${mod}+5" = "workspace 5";
            "${mod}+6" = "workspace 6";
            "${mod}+7" = "workspace 7";
            "${mod}+8" = "workspace 8";
            "${mod}+9" = "workspace 9";
            "${mod}+0" = "workspace 10";
            # ^ Cmd+number keys to switch to workspace 1–10 (e.g., Cmd+1 for workspace 1, ... Cmd+0 for workspace 10).
            #   This mimics macOS's Mission Control number keys for spaces (if configured similarly).
            #   We include 0 as 10th workspace for convenience.

            "${mod}+Shift+1" = "move container to workspace 1";
            "${mod}+Shift+2" = "move container to workspace 2";
            "${mod}+Shift+3" = "move container to workspace 3";
            "${mod}+Shift+4" = "move container to workspace 4";
            "${mod}+Shift+5" = "move container to workspace 5";
            "${mod}+Shift+6" = "move container to workspace 6";
            "${mod}+Shift+7" = "move container to workspace 7";
            "${mod}+Shift+8" = "move container to workspace 8";
            "${mod}+Shift+9" = "move container to workspace 9";
            "${mod}+Shift+0" = "move container to workspace 10";
            # ^ Cmd+Shift+number to move the focused window to that workspace (similar concept to dragging a window to another space).
          };

          # (Optional) You could bind a key to show the clipboard history menu:
          # For example, Cmd+Shift+V to pick from clipboard history:
          # "${mod}+Shift+v" = "exec clipman pick -t wofi";
          # And optionally auto-paste the selection by appending: && ${pkgs.wtype}/bin/wtype -P XF86Paste
          # This would let you choose an older copied item via a Wofi menu
          # (We leave it commented for now; use if desired.)

          # **Startup commands** – launched when Sway starts
          startup = [
            # Launch Waybar (status bar) on startup
            {command = "${pkgs.waybar}/bin/waybar";}
            # Start clipboard manager to persist clipboard & history
            {command = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store --no-persist";}
            {command = "${pkgs.wl-clipboard}/bin/wl-paste -p -t text --watch ${pkgs.clipman}/bin/clipman store -P --no-persist";}
            # ^ The above two commands run clipman in the background to save clipboard history.
            #   The first keeps the regular clipboard (selection) history, the second (`-p` for primary) does the primary selection.
            #   We use --no-persist to avoid saving non-text/complex data (see clipman known issues)
            #   Clipman will now remember clipboard contents even after the source app exits, and ensures you can paste them later.
            #   History is stored in memory (not persisted to disk in this mode).
            #   You can later press Cmd+V to paste as usual, or use clipman pick (as discussed above) to choose from history.
          ];

          # Disable Sway's default bar, as we're using Waybar
          bars = [];
          # ^ By setting no bars here, we prevent the default Sway bar from appearing (since Waybar is used instead).
          #   Waybar is launched via startup above. You can configure Waybar via Home Manager (programs.waybar)
          #   or by a custom config at ~/.config/waybar/config as needed.
        };
      };

      # Install key software: Sway, utilities, Waybar, etc.
      home.packages = with pkgs; [
        sway # Sway window manager
        foot # Foot terminal emulator (Wayland-native, lightweight)
        wofi # Wofi launcher (for app menu and window switcher)
        waybar # Waybar status bar (replaces Sway's default bar)
        grim # screenshot tool
        slurp # region selector for screenshot tool
        wl-clipboard # wl-copy and wl-paste for clipboard integration
        clipman # Clipman clipboard manager (stores clipboard history)
        wtype # wtype for simulating key presses (used to send Ctrl/Cmd keys)
        swaylock # Screen locker for Wayland (to lock the session)
        mako # Notification daemon (for on-screen notifications, optional)
      ];

      # Set environment variables for Wayland and app compatibility
      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland backend for Firefox (if installed)
        XDG_CURRENT_DESKTOP = "sway"; # Many apps and themes detect the desktop via this
        GTK_USE_PORTAL = "1"; # Use xdg-desktop-portal for file dialogs in sandboxed apps
        # (You can add more variables like QT_QPA_PLATFORM=wayland if needed for Qt apps)
      };
    }
  ]
