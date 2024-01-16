{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };
  outputs = { nixpkgs, ... }: {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      };

      defaults = { pkgs, ... }: {
        imports = [
          ./modules/base.nix
        ];
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
