{ boot, services, ... }:

{
  imports = [ ];

  boot.supportedFilesystems = [ "zfs" ];

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

}
