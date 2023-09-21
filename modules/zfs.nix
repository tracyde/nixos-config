{ boot, services, ... }:

{
  imports = [ ];

  boot.initrd.supportedFilesystems = [ "zfs" ];

  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

}
