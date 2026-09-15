{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ...}@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
       ./configuration.nix

       home-manager.nixosModules.home-manager {
         home-manager.useGlobalPkgs = true;
	 home-manager.useUserPackages = true;
	 home-manager.users.andrew = import ./home.nix;
       }
       ];
    };
  };
}
