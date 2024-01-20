{ system, services, pkgs, ... }:

{
  imports = [ ];

  # Allow the use of unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "US/Eastern";

  # Enable NixOS Flakes support
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    gc  = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    tree
    tmux
    curl
    wget
    ripgrep
    git
  ];

  # Enable starship terminal prompt
  programs.starship.enable = true;

  # Automatic system updates
  system.autoUpgrade.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
