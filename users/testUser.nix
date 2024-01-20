{ config, pkgs, home-manager, ... }: {

  programs.home-manager.enable = true;

  users.users.testUser.isNormalUser = true;

  #home-manager.users.testUser = { ... }: {

  #  home.username = "testUser";
  #  home.homeDirectory = "/home/testUser";

  #  home.packages = with pkgs; [
  #    fish
  #  ];
  #  home.stateVersion = "23.05";

  #};


}
