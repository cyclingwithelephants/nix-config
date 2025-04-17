{
  ###-------------------------------------------------------------------
  ###  Optimized, fully‑commented multi‑system flake
  ###-------------------------------------------------------------------
  description = "Optimized, fully commented multi-system flake";

  inputs = {
    nixpkgs = {url = "github:NixOS/nixpkgs/nixpkgs-unstable";};
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {url = "github:numtide/flake-utils";};
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    flake-utils,
    ...
  }: let
    # Supported platforms
    systems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];

    # Convenient helper to import nixpkgs for an arbitrary system
    pkgsFor = system: import nixpkgs {inherit system;};
  in
    #--------------------------------------------------------------------
    # Per‑system outputs (devShells, overlays, packages …)
    #--------------------------------------------------------------------
    flake-utils.lib.eachSystem systems (system: let
      pkgs = pkgsFor system;
    in {
      ###--------------------------------------------------------------
      ### Development shell (nix develop .)
      ###--------------------------------------------------------------
      devShells.default = pkgs.mkShell {
        buildInputs = [pkgs.nixpkgs-fmt pkgs.alejandra];

        shellHook = ''
          # 1) Re‑indent and normalize braces
          alias fmt-nix='nix fmt **/*.nix'

          # 2) Apply nixpkgs’ style conventions
          alias fmt-nixpkgs='nixpkgs-fmt **/*.nix'

          # 3) Run both formatters, then Alejandra’s lint+rewrite
          alias fmt-all='fmt-nix && fmt-nixpkgs && alejandra .'
        '';
      };
    })
    #--------------------------------------------------------------------
    # Top‑level outputs (no per‑system nesting!)
    #--------------------------------------------------------------------
    // {
      ###--------------------------------------------------------------
      ### macOS (Apple Silicon) configuration
      ###--------------------------------------------------------------
      darwinConfigurations.shallot = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [./modules/darwin-config.nix];
      };

      ###--------------------------------------------------------------
      ### Linux Home‑Manager configuration
      ###--------------------------------------------------------------
      homeConfigurations.turmeric = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor "aarch64-linux";
        modules = [./modules/linux-config.nix];
      };
    };
}
