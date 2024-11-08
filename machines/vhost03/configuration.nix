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

  # Network configuration
  networking = {
    hostId = "c267b675";
    hostName = "vhost03";
    domain = "lab.twistedcode.org";

    vlans = {
      vlan10 = { id=10; interface="eno4"; };
    };

    interfaces.vlan10.ipv4.addresses = [{
      address = "10.10.0.13";
      prefixLength = 24;
    }];
    defaultGateway = "10.10.0.1";
    nameservers = [ "192.168.100.10" ];

    hosts = {
      "10.10.0.13" = [ "vhost03" "vhost03.lab.twistedcode.org" ];
    };

  };

}
