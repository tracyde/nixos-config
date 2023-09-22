#!/usr/bin/env bash
set -e

# Assumptions:
#   - Running script from the installation iso
#   - BOXNUC8i7HVK1
#   - 2 1TB NVME Drives
#

PDISK=/dev/nvme0n1
SDISK=/dev/nvme1n1
RESERVE=10

# Start off by wiping the disks, this is useful in case they used to contain old raid/zfs/btrfs remnants
# This WILL remove everything from the disks.
wipefs -a $PDISK
wipefs -a $SDISK

# PARTITON DISK: 1 512MB EFI 100GB Root pool & REST LXD pool
# We are trying to use as much storage as we can from this system.
parted --script /dev/nvme0n1 -- \
  mklabel gpt \
  mkpart esp fat32 1MiB 512MiB \
  mkpart primary 512MiB 102400MiB \
  mkpart primary 102400MiB 100% 
  set 1 esp on
  set 1 boot on

# PARTITON DISK: 2 100% LXD pool
parted --script /dev/nvme1n1 -- \
  mklabel gpt \
  mkpart primary 1MiB 100% 

# CREATE The ROOT ZFS POOL
zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O mountpoint=none \
  -O acltype=posixacl \
  -O canmount=off \
  -O compression=lz4 \
  -O xattr=sa \
  -O relatime=on \
  rpool \
  /dev/nvme0n1p2

# CREATE The LXD ZFS POOL
zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O mountpoint=none \
  -O acltype=posixacl \
  -O canmount=off \
  -O compression=lz4 \
  -O xattr=sa \
  -O relatime=on \
  lxd \
  ${PDISK}p3 ${SDISK}p1


# CREATE A ROOT PARTITION
zfs create \
  -o mountpoint=legacy \
  rpool/root
mkdir -p /mnt
mount -t zfs rpool/root /mnt

# CREATE A NIX PARTITION
zfs create \
  -o mountpoint=legacy \
  -o atime=off \
  rpool/nix
mkdir -p /mnt/nix
mount -t zfs rpool/nix /mnt/nix

# CREATE A BOOT PARTITON
mkfs.fat -F 32 -n BOOT ${PDISK}p1
mkdir -p /mnt/boot
mount -t vfat ${PDISK}p1 /mnt/boot

# LEAVING THE BELOW COMMENTED OUT FOR NOW!
# NEED TO FIGURE OUT THE EXACT INSTALL PROCESS
# AND GRABBING THE GIT REPO

# NOW GENERATE NIXOS CONFIG FOR /mnt
# nixos-generate-config --root /mnt

# NOW ADD THE FOLLOWING TO /mnt/etc/nixos/configuration.nix
#
#   boot.initrd.supportedFilesystems = [ "zfs" ];
#   boot.supportedFilesystems = [ "zfs" ];
#   boot.zfs.enableUnstable = true;
#   services.zfs.autoScrub.enable = true;
# 
#   network.hostName = "pants";
#   network.hostId = "abcdef01";
# 

# NOW INSTALL NIXOS
# nixos-install

# NOW CLEANUP & REBOOT
# umount /mnt/{nix,boot}
# umount /mnt
# zpool export -a
# reboot
