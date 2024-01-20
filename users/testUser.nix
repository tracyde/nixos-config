{ pkgs, ... }: {

  home.username = "testUser";
  home.homeDirectory = "/home/testUser";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    fish
  ];
  home.stateVersion = "23.11";

}
