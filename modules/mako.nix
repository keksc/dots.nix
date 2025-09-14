{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font";
    };
  };
}
