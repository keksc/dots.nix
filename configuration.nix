# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    initrd = {
      verbose = false;
    };
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  musnix.enable = true;

  hardware.graphics.enable = true;

  boot.blacklistedKernelModules = [ "nouveau" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.enable = false;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

  services.journald.extraConfig = ''
    SystemMaxUse=50M
    RuntimeMaxUse=10M
  '';

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "colemak";

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri --session";
        user = "kekw";
      };
      initial_session = {
        command = "niri --session";
        user = "kekw";
      };
    };
  };

  environment.shells = [ pkgs.fish ];
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  users.users.kekw = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "adbusers"
      "audio"
    ];
    initialPassword = "tetris";
    useDefaultShell = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    nvidia-offload
    ntfs3g
    alsa-utils
    gnome-themes-extra
  ];

  security.polkit.enable = true;
  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  systemd.user.services.xdg-desktop-portal-gnome = {
    description = "Portal service (GNOME implementation)";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    environment = {
      GTK_THEME = "Adwaita";
      WAYLAND_DISPLAY = "wayland-0";
    };
    serviceConfig = {
      ExecStart = "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome";
      Restart = "on-failure";
    };
  };

  systemd.user.services.xdg-desktop-portal = {
    wants = [
      "xdg-desktop-portal-gtk.service"
      "xdg-desktop-portal-gnome.service"
    ];
    after = [
      "xdg-desktop-portal-gtk.service"
      "xdg-desktop-portal-gnome.service"
    ];
  };

  system.stateVersion = "24.11";

  programs.niri.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  networking.firewall.enable = false;

  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  systemd.services.tlp.wantedBy = lib.mkForce [ ];

  systemd.services.audit.serviceConfig = {
    Mask = true;
  };
  systemd.services."modprobe@drm.service".enable = false;
  systemd.services."modprobe@configfs.service".enable = false;

  programs.adb.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;
}
