{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";

      # optional, but recommended so it shares system libraries, and improves startup time
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lanzaboote,
      zen-browser,
      nixos,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration-iso.nix
            (
              { pkgs, modulesPath, ... }:
              {
                imports = [
                  "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

                  home-manager.nixosModules.home-manager
                ];

                environment.systemPackages = [ pkgs.neovim ];

                users.users.kekw = {
                  isNormalUser = true;
                  home = "/home/kekw"; # Correct field
                };

                home-manager.users.kekw = import ./home-iso.nix;
              }
            )
          ];
        };

        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            lanzaboote.nixosModules.lanzaboote
            (
              { pkgs, lib, ... }:
              {

                environment.systemPackages = [
                  # For debugging and troubleshooting Secure Boot.
                  pkgs.sbctl
                  zen-browser.packages.${pkgs.system}.default
                ];

                # Lanzaboote currently replaces the systemd-boot module.
                # This setting is usually set to true in configuration.nix
                # generated at installation time. So we force it to false
                # for now.
                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/etc/secureboot";
                };
              }
            )
          ];
        };
      };
      homeConfigurations = {
        kekw = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
