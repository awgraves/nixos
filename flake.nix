{
  description = "My nixos config entrypoint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix"; # use cached binary
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ...}@inputs: {
    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; }; # set all input params to be accessible in submodules
      modules = [
        ./hosts/thinkpad/configuration.nix

        home-manager.nixosModules.home-manager { 
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.andrew = import ./home.nix;
	  home-manager.backupFileExtension = ".bak";
	  home-manager.extraSpecialArgs = { 
	    inherit inputs;
            git-config-dir = "nixos"; # name of the repo dir in ~
	  }; # the specialArgs above only work for native nix modules
        }
      ];
    };
  };
}
