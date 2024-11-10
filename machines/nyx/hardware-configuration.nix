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
    initrd = {
      # `readlink /sys/class/net/enp0s31f6/device/driver` indicates "e1000e" is the ethernet driver for this device
      availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    };
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/389ba354-88e4-4fbd-afcb-202836912a4c";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A262-E6DF";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2c105a97-cb25-413b-a596-8251d8ecf407"; }
    ];

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
