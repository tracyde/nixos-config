{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops

    ./_packages.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    timeout = 10;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  sops = {
    defaultSopsFile = ./../../secrets/secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets."user_password".neededForUsers = true;
    secrets."user_password" = {};
    # inspo: https://github.com/Mic92/sops-nix/issues/427
    gnupg.sshKeyPaths = [];
  };

  users.mutableUsers = false;
  users.users.tracyde = {
    isNormalUser = true;
    description = "Derek Tracy";
    extraGroups = ["wheel" "libvirtd"];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrTOgNbi3vcEdqp0DRSdnSEdcouaKH8o7J7ofRMyFhJO8fNfn6SEHoPoQdqD3Uq4+Y7EHj1jVK5r/qrSpG/3ifdoBTyLKuK4AMIYNT6WoQIVqgcrhvhIMOM74um5Qbly/LvoZPOHh8Twce4RwX7CDMqh9O4u45HHQUMfkUPOi/N2lExgJ/WdgZBu+0XqDZQAsVq0NfabyGmFShsmJdAJ2Z1ofLzkH/lMUcrq8731gpqrt0hcSJA466mx7YYx2llIg9gJWaois2DwrmKJ3sm3VRM0ejLvj+4MXY3EBR5ZwBXbHpkf/IFHO/86MzoNYUYRXgB5+lPuXJstTWMQgqF0ORc+igPVVWjqo4gqBrPVMdfrx/gQuoTCycSUJDE3/M2g9/r05ZjEJS4f5I5X5759ToKIpekN7N0mJrMywTccQyjg4yvdqGyGXd0ngISwTmWOKP9CGkK9oV71SpvjR0IIp+uyQZxeI/Knjf2eYQopoIqYn4ghEZnZoX4JLo595GeTuFMCwCSeAO/GbrzUm6Ej+VNGKEtBZhPHDde9GDv5Xsp1TzU/MA7KnBx10ogk6MO1QZieykJ94TlFJVHUY3Xjh6CFbbFkg0aBdb3VfJdl7Zo31RmkKqpEn8kZWCS3yczMxLrIR5XsyjnUqCfn3Yz5jBa4ffO0UdfVwB+UYNMMI9yw=="
    ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets."user_password".path;
    # password = "Oiwifjxowdt3";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
    fstrim.enable = lib.mkDefault true;
  };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "America/New_York";

  # environment.persistence."/nix/persist" = {
  #   # Hide these mounts from the sidebar of file managers
  #   hideMounts = true;

  #   directories = [
  #     "/var/log"
  #     # inspo: https://github.com/nix-community/impermanence/issues/178
  #     "/var/lib/nixos"
  #   ];

  #   files = [
  #     "/etc/machine-id"
  #     "/etc/ssh/ssh_host_ed25519_key.pub"
  #     "/etc/ssh/ssh_host_ed25519_key"
  #     "/etc/ssh/ssh_host_rsa_key.pub"
  #     "/etc/ssh/ssh_host_rsa_key"
  #   ];
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
