{users, pkgs, inputs, ...}: 

{

  users.users.testUser.isNormalUser = true;
  inputs.home-manager.users.testUser = { pkgs, ... }: {
    home.username = "testUser";
    home.homeDirectory = "/home/testUser";
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      bat
    ];
    home.stateVersion = "23.11";
  };

}
