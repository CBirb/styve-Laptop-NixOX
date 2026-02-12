# 25.05 # 24.11 # 24.05

{
  description = "NixOS configuration with Musnix and multiple nixpkgs channels";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; # nixos-unstable
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05"; # nixos-unstable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # nixos-25.05
    nixpkgs-oldstable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-oldoldstable.url = "github:NixOS/nixpkgs/nixos-24.05";
    
    musnix.url = "github:musnix/musnix";


    home-manager = {
      # url = "github:nix-community/home-manager/release-25.05";
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    native-access-nix = {
      url = "github:yusefnapora/native-access-nix";

      # The following line is optional, but will use less disk space,
      # since it uses your existing nixpkgs input. If you use this and
      # native-access doesn't work, try removing it - there's a chance
      # that your current version of nixpkgs has an incompatible version
      # of wine.
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-stable, nixpkgs-oldstable, nixpkgs-oldoldstable, musnix, home-manager, native-access-nix, ... } @ inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };

      modules = [
        musnix.nixosModules.musnix

        ({
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };

              stable = import nixpkgs-stable {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };

              oldstable = import nixpkgs-oldstable {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };

              oldoldstable = import nixpkgs-oldoldstable {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };
            })
          ];
        })

        ./configuration.nix
        home-manager.nixosModules.home-manager
        home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.steve = ./home.nix; # replace <USERNAME> with your actual username
          }
      ];
    };
  };
}


