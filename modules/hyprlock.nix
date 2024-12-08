{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = true;
        no_fade_out = true;
        grace = 0;
        hide_cursor = true;
        disable_loading_bar = true;
      };

      background = [
        {
          path = "${./assets/yandere.png}";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 2;
        }
      ];

      input-field = [
        {
          outline_thickness = 3;
          inner_color = "rgba(0, 0, 0, 0.0)"; # no fill
          outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
          fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";
          font_color = "rgb(143, 143, 143)";
          fade_on_empty = false;
          rounding = 15;
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          text = "cmd[update:1000] echo \"$(whoami)\"";
          color = "#cdd6f4";
          font_size = 14;
          font_family = "JetBrains Mono";
          position = "0, -10";
          halign = "center";
          valign = "top";
        }
      ];
      image = [
        {
          path = "${./assets/thecat.png}";
          size = 150;
          rounding = 0;
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
