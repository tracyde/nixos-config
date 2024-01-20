#{ config, pkgs, home-manager, ... }: {
#
#  programs.home-manager.enable = true;
#
#  users.users.testUser.isNormalUser = true;
#
#  #home-manager.users.testUser = { ... }: {
#
#  #  home.username = "testUser";
#  #  home.homeDirectory = "/home/testUser";
#
#  #  home.packages = with pkgs; [
#  #    fish
#  #  ];
#  #  home.stateVersion = "23.05";
#
#  #};
#
#
#}

{config, pkgs, ... }: {

  home.username = "testUser";
  home.homeDirectory = "/home/testUser";

  users.users.testUser.isNormalUser = true;
  home.packages = [ pkgs.atool pkgs.httpie ];
  programs.bash.enable = true;
  
  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

