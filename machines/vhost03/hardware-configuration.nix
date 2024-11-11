{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
    initrd = {
      # `readlink /sys/class/net/enp0s31f6/device/driver` indicates "e1000e" is the ethernet driver for this device
      availableKernelModules = ["nvme" "xhci_pci" "ehci_pci" "ahci" "mpt3sas" "usbhid" "usb_storage" "sd_mod" "ixgbe"];
    };
    kernelModules = [ "kvm-intel" "sch_netem" "sch_ingress" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
