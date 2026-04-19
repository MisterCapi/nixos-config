{ ... }:
{
  flake.nixosModules.users = { config, ... }: {
    users.users.${config.my.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
      initialPassword = "changeme";
    };
    users.users.root.initialPassword = "changeme";
  };
}
