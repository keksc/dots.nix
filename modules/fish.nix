{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
      set -g fish_greeting
    '';
    shellInitLast = ''
      taoq
    '';
  };
}
