# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ../../machines/r710

      # Include base machine
      ../../modules/base.nix

      # Include system class
      ../../modules/server.nix
      
      # Include lxd
      ../../modules/lxd.nix

      # Include common users
      ../../users/tracyde.nix
    ];

  networking = {
    hostName = "vhost01"; # Define your hostname.
    domain = "lab.twistedcode.org";
    search = [ "lab.twistedcode.org" ];
    hostId = "611ed32e"; # `head -c 8 /etc/machine-id`
    dhcpcd.enable = false;
    defaultGateway = "10.10.0.1";
    nameservers = [ "192.168.100.10" ];
    firewall.enable = false;
    interfaces.eno1.ipv4 = {
      addresses = [{
        address = "10.10.0.11";
        prefixLength = 24;
      }];
      routes = [{
        address = "192.168.100.0";
	prefixLength = 24;
	via = "10.10.0.1";
	options = { metric = "0"; };
      }];
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}


