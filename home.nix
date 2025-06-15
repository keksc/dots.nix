{
  config,
  pkgs,
  inputs,
  ...
}:

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
    davinci-resolve
    ffmpeg
    ardour
    vital
    blender
    pwvucontrol

    xwayland-satellite

    nemo
    television

    vesktop
    brightnessctl
    wget2

    wf-recorder
    hyprpicker
    hyprshot

    libnotify
    timg # image, pdf and video viewer
    cmus

    gnuplot

    wl-clipboard

    unzip

    krita
    inkscape

    android-studio

    qalculate-gtk

    helvum

    # nvim
    neovim
    nixfmt-rfc-style
    lua-language-server
    ripgrep

    # dev pkgs i use most
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    vulkan-headers
    glfw
    fmt
    glm
    cmake
    shaderc
    openal
    clang-tools
    cmake-language-server
    stb
    simdjson
    curl
    gcc
    gdb
    gfxreconstruct
    fftwFloat

    renderdoc

    cloc

    pnpm
    nodejs

    sioyek

    swaybg

    inputs.zen-browser.packages."${pkgs.system}".default

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
    #"assets".source = ./assets;

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

  imports = [
    # ./modules/dunst.nix
    ./modules/git.nix
    ./modules/fish.nix
    ./modules/wofi.nix
    ./modules/kitty.nix
    # ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/wlogout.nix
    # ./modules/hyprlock.nix
  ];

  programs.fuzzel = {
    enable = true;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      download = "${config.home.homeDirectory}/dwl";
      music = "${config.home.homeDirectory}/music";
      videos = "${config.home.homeDirectory}/videos";
      documents = "${config.home.homeDirectory}/docs";
      pictures = "${config.home.homeDirectory}/images";
    };
  };
  programs.btop.enable = true;
  programs.mpv.enable = true;
  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 60;
      input.method = "pipewire";
      smoothing.noise_reduction = 88;
      color = {
        background = "'#1C2433'";
        foreground = "'#FFFFFF'";
      };
    };
  };

  programs.swaylock.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  services.home-manager.autoExpire = {
    enable = true;
    frequency = "monthly";
    timestamp = "-30 days";
    store = {
      cleanup = true;
      options = "--delete-older-than 30d";
    };
  };

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "monthly";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
