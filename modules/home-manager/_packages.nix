{
  pkgs,
  osConfig,
  ...
}: {
  home = {
    packages = with pkgs;
      [
        bat
        kubectl
      ]
      # Below packages are for development and therefore excluded from servers
      # inspo: https://discourse.nixos.org/t/how-to-use-hostname-in-a-path/42612/3
      # TODO: find a better way to implement this, something like a custom option
      # example: https://librephoenix.com/2023-12-26-nixos-conditional-config-and-custom-options
      ++ (
        if builtins.substring 0 5 osConfig.networking.hostName != "vhost"
        then [
          alejandra
          just
          nil
          nixos-rebuild # need for macOS
          sops
          statix
          hugo
        ]
        else []
      );
  };
}
