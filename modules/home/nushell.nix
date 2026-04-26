{ ... }:
{
  flake.homeModules.nushell = {
    programs.nushell = {
      enable = true;

      shellAliases = {
        # eza
        tree = "eza --tree --group-directories-first --icons=auto";

	# nixos
	nixswitch = "sudo nixos-rebuild switch --flake";
	nixtest = "sudo nixos-rebuild test --flake";
      };
    };
  };
}
