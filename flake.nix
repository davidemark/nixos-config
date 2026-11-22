{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, nix-cachyos-kernel, ... }:
    let
      # One workstation: hosts/<host>/configuration.nix (system) and hosts/<host>/home.nix (home-manager,
      # as a NixOS module, so one rebuild updates both). extraModules are host-specific system modules.
      mkHost = host: extraModules: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.davidemark = import ./hosts/${host}/home.nix;
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
            ];
          }
        ] ++ extraModules;
      };
    in
    {
      nixosConfigurations = {
        master = mkHost "master" [
          { nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ]; }
        ];
        s720 = mkHost "s720" [ ];
        t480 = mkHost "t480" [ ];
        hp = mkHost "hp" [ ];
        d3d3 = mkHost "d3d3" [ ];
      };
    };
}
