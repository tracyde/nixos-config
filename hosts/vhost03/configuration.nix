# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ../../machines/nuc8i

      # Include base machine
      ../../modules/base.nix

      # Include system class
      ../../modules/server.nix

      # Include common users
      ../../users/tracyde.nix
    ];

  networking.hostName = "vhost03"; # Define your hostname.
  networking.domain = "lab.twistedcode.org";
  networking.hostId = "8806318f"; # `head -c 8 /etc/machine-id`

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

