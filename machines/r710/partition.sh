#!/usr/bin/env bash
set -e

# Assumptions:
#   - Running script from the installation iso
#   - DELL R710
#   - 6 3TB NVME Drives
#

DISK1=/dev/sdc
DISK2=/dev/sdd
DISK3=/dev/sde
DISK4=/dev/sdf
DISK5=/dev/sdg
DISK6=/dev/sdh

RESERVE=10

# Start off by wiping the disks, this is useful in case they used to contain old raid/zfs/btrfs remnants
# This WILL remove everything from the disks.
wipefs -a $DISK1 $DISK2 $DISK3 $DISK4 $DISK5 $DISK6

# PARTITON DISK: 1 512MB EFI 100GB Root pool & REST LXD pool
# We are trying to use as much storage as we can from this system.
boot_partition() {
  parted --script "$1" -- \
    mklabel gpt \
    mkpart esp fat32 1MiB 512MiB \
    mkpart primary 512MiB 102400MiB \
    mkpart primary 102400MiB 100% 
    set 1 esp on
    set 1 boot on
}

# PARTITON DISK: 2 100% LXD pool
lxd_partition() {
  parted --script "$1" -- \
    mklabel gpt \
    mkpart primary 1MiB 100% 
}

boot_partition $DISK1
boot_partition $DISK2
lxd_partition $DISK3
lxd_partition $DISK4
lxd_partition $DISK5
lxd_partition $DISK6

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
  rpool mirror \
  ${DISK1}2 ${DISK2}2

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
  lxd raidz \
  ${DISK1}3 ${DISK2}3 ${DISK3}1 ${DISK4}1 ${DISK5}1 ${DISK6}1


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
mkfs.fat -F 32 -n BOOT ${DISK1}1
mkfs.fat -F 32 -n FALLBACK ${DISK2}1
mkdir -p /mnt/boot /mnt/boot-fallback
mount -t vfat ${DISK1}1 /mnt/boot
mount -t vfat ${DISK2}1 /mnt/boot-fallback

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
