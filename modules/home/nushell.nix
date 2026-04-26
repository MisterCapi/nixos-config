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
      # Default sort of `ls` was annoying so here are aliases to fix it
      extraConfig = ''
        def lla [...args] { ls -la ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def la  [...args] { ls -a  ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def ll  [...args] { ls -l  ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
        def l   [...args] { ls     ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
      '';
    };
  };
}
