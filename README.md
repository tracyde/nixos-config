This repository contains the Nix / NixOS configuration for all of my systems.

## Setup

To use this repository as base configuration for your new machine running:

### NixOS Linux

- Install NixOS
- Clone this repo to `/etc/nixos`
- Link `configuration.nix` to the `hosts/<hostname>/configuration.nix`
  - If you need to create a new hostname configuration.nix file
    - `mkdir hosts/<hostname>`
    - copy a configuration from a similar system
    - tailor the configuration.nix to suit your needs
    - ensure `networking.hostId` and `networking.hostname` are set correctly
    - make sure you import any and all users the system needs

## Architecture

Modulesque architecture (new to NixOS, so I am learning).  Concept is to capture generic settings at the level of abstraction that makes the most sense.  My homelab is a collection of computing equipment, so I am largely organizing by hardware configuration.

The idea is pretty simple, each machine type (hardware wise) will have a corresponding directory in `machines`.  That directory should also contain a script that will help configure the raw system into one running nixos, this will typically be installed `install.sh` and should do the following:

- Setup any special hardware on the system
- Partition hard drives
- Format hard drives
- Mount filesystems
- Move configuration repo (this repo) into `/etc/nixos` directory
- Run nixos-install (also installs bootloader)
- Un-mount filesystems
- Export mounts (like ZFS)
- Reboot

### Directory Layout

- `hosts`: contains directories containing tailored configurations for all systems
- `machines`: base hardware system configuration
- `modules`: common nix configuration for various items, meant to be directly imported into configurations
- `users`: user information and configuration
