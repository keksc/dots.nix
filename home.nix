{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kekw";
  home.homeDirectory = "/home/kekw";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    brightnessctl
    vesktop
    blender
    wget2

    wf-recorder

    hyprpicker
    hyprshot

    libnotify
    timg # image, pdf and video viewer
    musikcube # music player

    wl-clipboard
    font-awesome

    unzip

    # nvim
    nixfmt-rfc-style
    lua-language-server
    ripgrep

    android-studio

    nerd-fonts.jetbrains-mono

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kekw/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  imports = [ ./modules/dunst.nix ./modules/git.nix ./modules/fish.nix ./modules/gtk.nix ./modules/wofi.nix ./modules/kitty.nix ./modules/hyprland.nix ./modules/waybar.nix ./modules/wlogout.nix ./modules/hyprlock.nix ./modules/hyprpaper.nix ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      download = "${config.home.homeDirectory}/dwl";
      music = "${config.home.homeDirectory}/music";
      videos = "${config.home.homeDirectory}/videos";
      documents = "${config.home.homeDirectory}/docs";
    };
  };
  programs.btop.enable = true;

  programs.firefox = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
