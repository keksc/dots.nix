{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      input = {
        kb_layout = "us";
        kb_variant = "colemak";
        touchpad = {
          natural_scroll = true;
          disable_while_typing = false;
        };
      };
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      misc = {
        disable_hyprland_logo = true;
        enable_anr_dialog = false;
      };
      animations = {
        enabled = true;

        bezier = [
          "bezier1, 0.05, 0.7, 0.1, 1.05"
        ];
        animation = [
          "windows, 1, 7, bezier1"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      bind =
        [
          "$mod, Q, exec, kitty"
          "$mod, C, killactive,"
          "$mod, M, exit,"
          "$mod, V, togglefloating,"
          "$mod, R, exec, wofi"
          "$mod, F, exec, zen"
          "$mod, P, exec, hyprpicker -a -f rgb"
          "$mod SHIFT, P, exec, hyprpicker -a -f hex"
          "$mod SHIFT, F, fullscreen,"
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
          "$mod, T, workspace, special:magic"
          "$mod, T, exec, kitty"
          ", PRINT, exec, hyprshot --clipboard-only -m region -s -z"
          ", mouse:279, workspace, -1"
          ", mouse:280, workspace, +1"
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, d"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_min_fingers = true;
        workspace_swipe_distance = 900;
        workspace_swipe_cancel_ratio = 0.3;
        workspace_swipe_forever = true;
        workspace_swipe_min_speed_to_force = 3;
        workspace_swipe_direction_lock = false;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];
      env = [
        "XCURSOR_THEME,Vimix-cursors"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];
      cursor = {
        no_hardware_cursors = true;
      };
      exec-once = [
        "waybar"
        "hyprlock --immediate --immediate-render"
      ];
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgb(cdd6f4) rgb(6b140a) 45deg"; # "rgb(ab1eb3) rgb(de26c8) 45deg";
        "col.inactive_border" = "rgb(090000)"; # "rgba(595959aa)");
      };
      windowrulev2 = [
        "opacity 0.90 0.90,class:^(zen)$"
        "opacity 0.90 0.90,class:^(io.github.Qalculate.qalculate-qt)$"
        "opacity 0.80 0.80,class:^(sioyek)$"
        "opacity 0.90 0.90,class:^(resolve)$"
        "opacity 0.90 0.90,class:^(obsidian)$"
        "opacity 0.80 0.80,class:^(kitty)$"
        "opacity 0.80 0.80,class:^(qt5ct)$"
        "opacity 0.80 0.80,class:^(qt6ct)$"
        "opacity 0.80 0.70,class:^(nm-applet)$"
        "opacity 0.80 0.70,class:^(nm-connection-editor)$"
        "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "opacity 0.80 0.70,class:^(polkit-gnome-authentication-agent-1)$"
        "opacity 0.80 0.70,class:^(org.freedesktop.impl.portal.desktop.gtk)$"
        "opacity 0.80 0.70,class:^(org.freedesktop.impl.portal.desktop.hyprland)$"

        "opacity 0.80 0.80,class:^(com.obsproject.Studio)$"
        "opacity 0.80 0.80,class:^(vesktop)$"

        "float,class:^(kitty)$,title:^(btop)$"
        "float,class:^(vlc)$"
        "float,class:^(qt5ct)$"
        "float,class:^(qt6ct)$"
        "float,class:^(org.kde.ark)$"
        "float,class:^(blueman-manager)$"
        "float,class:^(nm-applet)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"

        "opacity 0.80 0.80,class:^(app.drey.Warp)$ # Warp-Gtk"
      ];
      layerrule = [
        "blur,wofi"
        "ignorezero,wofi"
        "blur,notifications"
        "ignorezero,notifications"
        "blur,logout_dialog"
      ];
      monitor = [
        "DP-1, preferred, auto, auto"
        ", preferred, auto, 1"
      ];
    };
  };
}
