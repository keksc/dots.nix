{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Define the taoq package
  taoq = pkgs.stdenv.mkDerivation rec {
    pname = "taoq";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "keksc";
      repo = "taoq";
      rev = "ead575fd35bcb5b0547806d03fede53d8b5fce95";
      sha256 = "1gcznn52f5n1n3diwvli718imnyyvrc64z8pjg46wxhdabc2kknl";
    };

    nativeBuildInputs = [
      pkgs.cmake
      pkgs.gcc
    ];
    buildInputs = [ pkgs.fmt ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_CXX_STANDARD=20"
      "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp taoq $out/bin/
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Misc fortunes";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
in
{
  home.username = "kekw";
  home.homeDirectory = "/home/kekw";
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  # Add overlay to make taoq available as pkgs.taoq
  nixpkgs.overlays = [
    (final: prev: {
      taoq = taoq;
    })
  ];

  home.packages = with pkgs; [
    kdePackages.filelight

    signal-desktop

    reaper
    ardour
    vital
    sfizz
    guitarix

    taoq
    davinci-resolve
    ffmpeg

    blender
    pwvucontrol
    xwayland-satellite
    television
    vesktop
    brightnessctl
    wget2
    wf-recorder
    hyprpicker
    hyprshot
    libnotify
    timg
    cmus
    gnuplot
    wl-clipboard
    unzip
    krita
    inkscape
    android-studio
    qalculate-gtk
    helvum
    neovim
    nixfmt-rfc-style
    lua-language-server
    ripgrep
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    vulkan-headers
    glfw
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
    linuxPackages_latest.perf
    flamegraph
    renderdoc
    cloc
    pnpm
    nodejs
    sioyek
    swaybg
    osu-lazer-bin
    inputs.zen-browser.packages."${pkgs.system}".default
    nemo
  ];

  home.file = {
    # Define files as needed
  };

  home.sessionVariables = {
    # Define variables as needed
  };

  imports = [
    # ./modules/dunst.nix
    ./modules/git.nix
    ./modules/fish.nix
    ./modules/wofi.nix
    ./modules/kitty.nix
    ./modules/niri.nix
    # ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/wlogout.nix
    # ./modules/hyprlock.nix
    ./modules/eww.nix
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
      };
      colors.background = "#da69dbe1";
    };
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
    portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = "gtk";
        };
      };
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

  programs.home-manager.enable = true;
}
