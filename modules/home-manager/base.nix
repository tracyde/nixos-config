{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./_packages.nix
    ./_zsh.nix
  ];

  home = {
    username = lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux "tracyde")
      (lib.mkIf pkgs.stdenv.isDarwin "tderek")
    ];
    homeDirectory = lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux "/home/tracyde")
      (lib.mkIf pkgs.stdenv.isDarwin "/Users/tderek")
    ];
    stateVersion = "24.05";
    sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
      EDITOR = "nvim";
      SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Derek Tracy";
      userEmail = "tracyde@gmail.com";
      # delta = {
      #   enable = true;
      # };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    # zellij = {
    #   enable = true;
    #   settings = {
    #     theme = "dracula";
    #   };
    # };
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    ranger.enable = true;
    fastfetch.enable = true;
  };

  # Nicely reload system units when changing configs
  # Self-note: nix-darwin seems to luckily ignore this setting
  systemd.user.startServices = "sd-switch";
}
