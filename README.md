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

### Directory Layout

- `hosts`: contains directories containing tailored configurations for all systems
- `machines`: base hardware system configuration
- `modules`: common nix configuration for various items, meant to be directly imported into configurations
- `users`: user information and configuration
