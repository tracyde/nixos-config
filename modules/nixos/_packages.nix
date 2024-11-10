{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    gptfdisk
    parted
    htop
    curl
    wget
  ];
}
