{ services, pkgs, ... }:

{
  imports = [ ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    linux-firmware
    neovim
    tree
    curl
    wget
    ripgrep
    git
  ];

}
