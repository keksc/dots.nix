{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    style = ./waybarstyle.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "left";
        width = 28;
        margin = "2 0 2 2";

        modules-left = [
          "clock"
          #"custom/sep"
          #"custom/wf-recorder"
        ];
        modules-center = [ /*"niri/workspaces"*/ ];
        modules-right = [
          "battery"
          "custom/sep"
          "temperature"
          "custom/sep"
          "wireplumber"
          "custom/powermenu"
        ];

        "custom/sep" = {
          format = "-";
        };
        "custom/powermenu" = {
          on-click = "wlogout";
          format = "";
          tooltip = false;
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            active = "";
            urgent = "";
            default = "";
          };
        };
        "clock" = {
          tooltip = true;
          format = "{:%H\n%M}";
          tooltip-format = "{:%Y-%m-%d}";
        };
        "custom/wf-recorder" = {
          exec = pkgs.writeShellScript "waybar-record" ''

          '';
          return-type = "json";
          interval = 1;
          on-click = pkgs.writeShellScript "record" ''

          '';
          tooltip = true;
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          rotate = 90;
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        "temperature" = {
          rotate = 90;
          hwmon-path = "/sys/class/hwmon/hwmon0/temp1_input";
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        "wireplumber" = {
          rotate = 90;
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "MUTE ";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          scroll-step = 3;
          on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        };
      };
    };
  };
}
