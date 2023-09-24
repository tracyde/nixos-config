{ config, pkgs, ... }:

{
  imports =
    [ 
      ../../machines/xps13

      # Include base machine
      ../../modules/base.nix

      # Include system class
      ../../modules/desktop.nix
      
      # Include common users
      ../../users/tracyde.nix
    ];

  networking.hostName = "nyx"; # Define your hostname.
  networking.domain = "nexus.twistedcode.org";
  networking.hostId = "a6c42a1b"; # `head -c 8 /etc/machine-id`

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
  ];

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}

