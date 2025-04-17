{
  description = "Unified Nix config for macOS, Linux desktop, and server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

#  outputs = {
#    self,
#    nixpkgs,
#    home-manager,
#    darwin,
#    flake-utils,
#    ...
#  }: let
#    mkSystem = system: hostFile:
#      nixpkgs.lib.nixosSystem {
#        inherit system;
#        modules = [
#          ./hosts/${hostFile}
#          home-manager.nixosModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.useUserPackages = true;
#            home-manager.users.adam = import ./users/adam/home.nix;
#          }
#        ];
#      };
#
#    mkDarwin = system: hostFile:
#      darwin.lib.darwinSystem {
#        inherit system;
#        modules = [
#          ./hosts/${hostFile}
#          home-manager.darwinModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.useUserPackages = true;
#            home-manager.users.adam = import ./users/adam/home.nix;
#          }
#        ];
#      };
#  in {
#    nixosConfigurations = {
#      turmeric-aarch64-linux = mkSystem "aarch64-linux" "turmeric/default.nix";
#      turmeric-x86_64-linux = mkSystem "x86_64-linux" "turmeric/default.nix";
#    };
#
#    darwinConfigurations = {
#      shallot = mkDarwin "aarch64-darwin" "shallot/default.nix";
#    };
#
##    apps = flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (system: {
##      build-turmeric = {
##        type = "app";
##        program = "${nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild";
##        args = ["switch" "--flake" ".#turmeric-${system}"];
##      };
##    });
#
#    packages = flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (system: {
#      turmeric = self.nixosConfigurations."turmeric-${system}".config.system.build.toplevel;
#    });
#  };
outputs = inputs@{ self
                 , nixpkgs
                 , home-manager
                 , darwin
                 , flake-utils
                 , ...
                 }:
let
  # ---- Common helpers --------------------------------------------------
  systems = ["x86_64-linux" "aarch64-linux"];

  mkSystem = system: hostFile:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/${hostFile}
        home-manager.nixosModules.home-manager
        { home-manager.useGlobalPkgs  = true;
          home-manager.useUserPackages = true;
          home-manager.users.adam     = import ./users/adam/home.nix;
        }
      ];
    };

  mkDarwin = system: hostFile:
    darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./hosts/${hostFile}
        home-manager.darwinModules.home-manager
        { home-manager.useGlobalPkgs  = true;
          home-manager.useUserPackages = true;
          home-manager.users.adam     = import ./users/adam/home.nix;
        }
      ];
    };

  # ---- 1.  system‑independent outputs ----------------------------------
  nixosConfigurations = {
    "turmeric-aarch64-linux" = mkSystem "aarch64-linux" "turmeric/default.nix";
    "turmeric-x86_64-linux"  = mkSystem "x86_64-linux"  "turmeric/default.nix";
  };

  darwinConfigurations = {
    shallot = mkDarwin "aarch64-darwin" "shallot/default.nix";
  };

  # ---- 2.  per‑system outputs (packages, devShells, …) -----------------
  perSystem = flake-utils.lib.eachSystem systems (system: {
    packages.turmeric =
      nixosConfigurations."turmeric-${system}".config.system.build.toplevel;
  });

in
# ---- 3.  merge the two attrsets ---------------------------------------
perSystem // { inherit nixosConfigurations darwinConfigurations; };

}
