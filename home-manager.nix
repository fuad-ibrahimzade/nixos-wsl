{ config, pkgs, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "release-21..05"; # the branch to follow: release-xx.yy for stable nixos or master for nixos-unstable.
  };
in
{
    imports = [
      (import "${home-manager}/nixos")
    ];

    home.manager.programs.zsh.initExtra = "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
    home.manager.programs.zsh.    initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

    home-manager.users.user = {
        isNormalUser = true;
        createHome = true;
        home = "/home/user";
        extraGroups = [ "wheel" "networkmanager" ];
    };

    nix.autoOptimiseStore = true;
    nix.gc = {
        automatic = true;
        options = "--delete-older-than 14d";
    };
    nix.gc.dates = "20:15";
}