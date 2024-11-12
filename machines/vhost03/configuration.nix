{
  inputs,
  outputs,
  ...
}: {
  imports = [
    # inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix

    ./../../modules/nixos/base.nix
    ./../../modules/zfs/base.nix
    #./../../modules/nixos/remote-unlock.nix
    #./../../modules/nixos/auto-update.nix

    #./../../services/tailscale.nix
    # ./../../services/netdata.nix
    #./../../services/nextcloud.nix
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      tracyde = {
        imports = [
          ./../../modules/home-manager/base.nix
        ];
      };
    };
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.allowedBridges = [ "br-mgmt" ];
  environment.systemPackages = with pkgs; [ "virt-manager" ];

  # Network configuration
  networking.useDHCP = false;

  networking = {
    hostId = "c267b675";
    hostName = "vhost03";
    domain = "lab.twistedcode.org";
    defaultGateway = "10.10.0.1";
    nameservers = [ "192.168.100.10" ];

    vlans = {
      vlan10 = { id=10; interface="eno4"; };
    };

    bridges = {
      br-mgmt = {
        interfaces = [ "vlan10" ];
      };
    };

    interfaces.br-mgmt.ipv4.addresses = [{
      address = "10.10.0.13";
      prefixLength = 24;
    }];


    hosts = {
      "10.10.0.13" = [ "vhost03" "vhost03.lab.twistedcode.org" ];
    };

  };

}
