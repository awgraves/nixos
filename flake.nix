{
  description = "My nixos config entrypoint";

  # adding these directly in the flake allows it to happen on first build
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix"; # use cached binary
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ...}@inputs:
  let
    common-home-manager-settings = { 
        	  home-manager.useGlobalPkgs = true;
        	  home-manager.useUserPackages = true;
        	  home-manager.users.andrew = import ./home.nix;
        	  home-manager.backupFileExtension = ".bak";
        	  home-manager.extraSpecialArgs = { 
        	    inherit inputs;
              git-config-dir = "nixos"; # name of the repo dir in ~
        	  }; # the specialArgs above only work for native nix modules
          };

    hosts = ["thinkpad"];
    mkHost = host: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; }; # set all input params to be accessible in submodules
      modules = [
        ./hosts/common.nix
        ./hosts/${host}/configuration.nix
        home-manager.nixosModules.home-manager
        common-home-manager-settings
      ];
    };
  in
  {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
  };
}
