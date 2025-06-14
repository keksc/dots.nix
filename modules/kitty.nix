{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 9;
    };
    shellIntegration.enableFishIntegration = true;
    keybindings = {
      "f1" = "launch --cwd=current --type=tab nvim";
      "f2" = "launch --cwd=current --type=tab";
      "kitty_mod+f1" = "show_kitty_doc overview";
    };
    settings = {
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
      window_padding_width = 25;

      foreground = "#CDD6F4";
      background = "#1C2433";
      selection_foreground = "#1C2433";
      selection_background = "#F5E0DC";
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      url_color = "#B4BEFE";
      active_border_color = "#CBA6F7";
      inactive_border_color = "#8E95B3";
      bell_border_color = "#EBA0AC";

      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";

      mark1_foreground = "#1E1E2E";
      mark1_background = "#87B0F9";
      mark2_foreground = "#1E1E2E";
      mark2_background = "#CBA6F7";
      mark3_foreground = "#1E1E2E";
      mark3_background = "#74C7EC";

      color0 = "#43465A";
      color8 = "#43465A";

      color1 = "#F38BA8";
      color9 = "#F38BA8";

      color2 = "#A6E3A1";
      color10 = "#A6E3A1";

      color3 = "#F9E2AF";
      color11 = "#F9E2AF";

      color4 = "#87B0F9";
      color12 = "#87B0F9";

      color5 = "#F5C2E7";
      color13 = "#F5C2E7";

      color6 = "#94E2D5";
      color14 = "#94E2D5";

      color7 = "#CDD6F4";
      color15 = "#A1A8C9";
    };
  };
}
