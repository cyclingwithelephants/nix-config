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
wayland.windowManager.sway = {
  enable = true;

  # Use the wrapped sway that the module already injects.
  # *Do not* add pkgs.sway to `home.packages`, or you’ll get a path‑collision.
  wrapperFeatures.gtk = true;         # inherit GTK theme & portals
  checkConfig        = true;          # validate generated file at HM switch
  systemd.enable     = true;          # launch via systemd‑user unit

  config = rec {
    modifier = "Mod4";
    terminal = "foot";                # ← change to "alacritty" if preferred
    menu     = "wofi --show drun";
    fonts    = {
      names = [ "Inter" "Noto Sans" ];
      style = "Regular";
      size  = 10.0;
    };

    ### Key‑bindings — keep the defaults and add a few custom ones
    keybindings = lib.mkOptionDefault {
      "${modifier}+Return" = "exec ${terminal}";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+d"       = "exec ${menu}";
      "${modifier}+Shift+s" = ''
        exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | wl-copy
      '';                        # region screenshot to clipboard :contentReference[oaicite:2]{index=2}
      "Print" = "exec ${pkgs.grim}/bin/grim ~/Pictures/$(date +'%F_%T').png";
      "${modifier}+Shift+l" = "exec swaylock -f";  # manual lock
    };

    ### Gaps & floating rules
    gaps = {
      inner = 8;
      outer = 4;
      smartBorders = "on";
    };

    floating.criteria = [
      { class = "pavucontrol"; }
      { title = "File Upload"; }
    ];

    ### Inputs — natural scrolling & tap‑to‑click on touchpads
    input = {
      "type:touchpad" = {
        natural_scroll = "enabled";
        tap            = "enabled";
        drag_lock      = "enabled";
        pointer_accel  = "0.4";
      };
      "type:keyboard" = {
        xkb_layout = "gb";
      };
    };

    ### Outputs — single monitor example; add more blocks as needed
    output = {
      "*" = {
#        bg = "~/Pictures/wallpapers/forest.jpg fill";
      };
    };

    ### Startup programs (run once per session)
    startup = [
      { command = "waybar";             always = true; }
      { command = "swayidle -w";        always = true; }
      { command = "wl-paste --watch cliphist store"; }
#      { command = "swaybg -i ~/Pictures/wallpapers/forest.jpg -m fill"; }
    ];
  };

  # Optional extraConfig for raw lines not covered by the module
  extraConfig = ''
    # focus follow mouse
    focus_follows_mouse yes
    mouse_warping none
  '';
};
      # this will append to packages, not replace
      home.packages = with pkgs; [
          # Wayland / Sway desktop bits
#          swayidle
#          wl-clipboard
#          foot # terminal
#          grim
#          slurp
#          waybar
#          wofi # application launcher
        ];

      # Wayland‑specific environment tweaks
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };
    }
  ]
