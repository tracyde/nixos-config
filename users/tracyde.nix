{ users, pkgs, ... }:

{
  imports = [ ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tracyde = {
    isNormalUser = true;
    description = "Derek Tracy";
    extraGroups = [ "networkManager" "wheel" "lxd" ];
    packages = with pkgs; [
      colmena
    ];
  };

  users.users.tracyde.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrTOgNbi3vcEdqp0DRSdnSEdcouaKH8o7J7ofRMyFhJO8fNfn6SEHoPoQdqD3Uq4+Y7EHj1jVK5r/qrSpG/3ifdoBTyLKuK4AMIYNT6WoQIVqgcrhvhIMOM74um5Qbly/LvoZPOHh8Twce4RwX7CDMqh9O4u45HHQUMfkUPOi/N2lExgJ/WdgZBu+0XqDZQAsVq0NfabyGmFShsmJdAJ2Z1ofLzkH/lMUcrq8731gpqrt0hcSJA466mx7YYx2llIg9gJWaois2DwrmKJ3sm3VRM0ejLvj+4MXY3EBR5ZwBXbHpkf/IFHO/86MzoNYUYRXgB5+lPuXJstTWMQgqF0ORc+igPVVWjqo4gqBrPVMdfrx/gQuoTCycSUJDE3/M2g9/r05ZjEJS4f5I5X5759ToKIpekN7N0mJrMywTccQyjg4yvdqGyGXd0ngISwTmWOKP9CGkK9oV71SpvjR0IIp+uyQZxeI/Knjf2eYQopoIqYn4ghEZnZoX4JLo595GeTuFMCwCSeAO/GbrzUm6Ej+VNGKEtBZhPHDde9GDv5Xsp1TzU/MA7KnBx10ogk6MO1QZieykJ94TlFJVHUY3Xjh6CFbbFkg0aBdb3VfJdl7Zo31RmkKqpEn8kZWCS3yczMxLrIR5XsyjnUqCfn3Yz5jBa4ffO0UdfVwB+UYNMMI9yw== tracyde"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrTOgNbi3vcEdqp0DRSdnSEdcouaKH8o7J7ofRMyFhJO8fNfn6SEHoPoQdqD3Uq4+Y7EHj1jVK5r/qrSpG/3ifdoBTyLKuK4AMIYNT6WoQIVqgcrhvhIMOM74um5Qbly/LvoZPOHh8Twce4RwX7CDMqh9O4u45HHQUMfkUPOi/N2lExgJ/WdgZBu+0XqDZQAsVq0NfabyGmFShsmJdAJ2Z1ofLzkH/lMUcrq8731gpqrt0hcSJA466mx7YYx2llIg9gJWaois2DwrmKJ3sm3VRM0ejLvj+4MXY3EBR5ZwBXbHpkf/IFHO/86MzoNYUYRXgB5+lPuXJstTWMQgqF0ORc+igPVVWjqo4gqBrPVMdfrx/gQuoTCycSUJDE3/M2g9/r05ZjEJS4f5I5X5759ToKIpekN7N0mJrMywTccQyjg4yvdqGyGXd0ngISwTmWOKP9CGkK9oV71SpvjR0IIp+uyQZxeI/Knjf2eYQopoIqYn4ghEZnZoX4JLo595GeTuFMCwCSeAO/GbrzUm6Ej+VNGKEtBZhPHDde9GDv5Xsp1TzU/MA7KnBx10ogk6MO1QZieykJ94TlFJVHUY3Xjh6CFbbFkg0aBdb3VfJdl7Zo31RmkKqpEn8kZWCS3yczMxLrIR5XsyjnUqCfn3Yz5jBa4ffO0UdfVwB+UYNMMI9yw== tracyde"
  ];

}

