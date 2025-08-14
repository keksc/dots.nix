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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <musnix>
  ];

  # Add overlay to make xdg-desktop-portal-gnome a no-op
  nixpkgs.overlays = [
    (final: prev: {
      xdg-desktop-portal-gnome = prev.stdenv.mkDerivation {
        name = "xdg-desktop-portal-gnome-empty";
        version = "48.0";
        # No source, no build, no output
        phases = [ "installPhase" ];
        installPhase = ''
          mkdir -p $out
        '';
        meta = {
          description = "Empty derivation to disable xdg-desktop-portal-gnome";
          license = prev.lib.licenses.mit;
          platforms = prev.lib.platforms.all;
        };
      };
    })
  ];

  boot = {
    initrd = {
      verbose = false;
      # compression = "zstd"; # instead of gzip
      # enableModuleDependency = false; # don’t auto-scan everything
      # kernelModules = lib.mkForce [
      #   # start with only what you actually need
      #   "nvme" # your root disk
      #   "xhci_pci" # USB
      #   "ahci" # SATA (if you have it)
      #   "ext4" # or btrfs, whichever fs you use
      #   "i915" # Intel iGPU (if applicable)
      #   # …add any others you saw in `lsinitrd` for your real hardware…
      # ];
    };
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
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
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = true;
    # Use the NVidia open source kernel module (not to be confused with nouveau).
    open = false;
    # Enable the Nvidia settings menu.
    nvidiaSettings = true;
    # Select the appropriate driver version.
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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  #services.ratbagd.enable = true;

  fonts.packages = with pkgs; [
    maple-mono.NF
    nerd-fonts.fira-code
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
  ];

  security.polkit.enable = true;
  security.rtkit.enable = true;

  # Explicitly configure xdg.portal to use only xdg-desktop-portal-gtk
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = {
        default = "gtk";
      };
    };
  };

  # Some programs need SUI
  system.stateVersion = "24.11";

  programs.niri.enable = true;
  # programs.hyprland.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config.allowUnfree = true;

  networking.firewall.enable = false;

  # Power management
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
}
