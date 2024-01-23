{

  description = "System Configurations served by Colmena [https://colmena.cli.rs/0.4/introduction.html]";

  # Other flakes we pull in
  inputs = {

    # Used for system packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Add the home-manager nixosModule
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Encrypt sensitive values before uploading to version control
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = 
        "nixpkgs"; # Use system packages list where available
    };


  };

  outputs = inputs@{ nixpkgs, home-manager, sops-nix, ... }: {

    # Colmena Section
    colmena = {

      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };

	# Inject the inputs for the top-level flake into a variable so the
        # nodes can pull them down consistently. I renamed this to flakes
        # instead of inputs since I always use `inputs` for my parameters
        # for nested Nix files.
        #specialArgs.flakes = inputs; = {
        #  flakes = inputs;
        #  system = system; # I cannot figure out the "correct" way to do this yet.
        #};
	specialArgs.inputs = inputs;
      };

      defaults = { pkgs, inputs, ... }: {
        imports = [
          ./modules/base.nix
	  sops-nix.nixosModules.sops
        ];


	#specialArgs = { inherit inputs; };
	#inputs.home-manager.nixosModules.home-manager {
	#  home-manager.useGlobalPkgs = true;
	#  home-manager.useUserPackages = true;
	#}

	sops.defaultSopsFile = ./secrets/secrets.yaml;
	sops.defaultSopsFormat = "yaml";

	sops.age.keyFile = "/home/tracyde/.config/sops/age/keys.txt";
      };

      bastion = { name, nodes, ... }: {
        networking.hostName = "bastion";
        networking.domain = "nexus.twistedcode.org";
        networking.hostId = "2e49df46"; # `head -c 8 /etc/machine-id`
        
	imports = [
          #../../machines/xps13
	  ./modules/base.nix

          # Include system class
          ./machines/precision/default.nix
          
          # Include common users
          ./users/tracyde.nix
	  ./users/testUser.nix

          # Profiles
          ./modules/desktop.nix
        ];
        
        deployment = {
          # Allow local deployment with `colmena apply-local`
          allowLocalDeployment = true;

          # Disable SSH deployment. This node will be skipped in a
          # normal`colmena apply`.
          targetHost = null;
        };
      };

    };

  };

}
