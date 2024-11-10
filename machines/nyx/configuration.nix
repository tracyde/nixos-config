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
    ./../../modules/nixos/desktop.nix
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

  # Network configuration
  networking = {
    hostId = "a6c42a1b";
    hostName = "nyx";
    domain = "nexus.twistedcode.org";
  };

}
