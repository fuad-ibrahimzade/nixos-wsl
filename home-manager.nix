{ config, pkgs, ... }:
{
    # The home-manager manual is at:
    #
    #   https://rycee.gitlab.io/home-manager/release-notes.html
    #
    # Configuration options are documented at:
    #
    #   https://rycee.gitlab.io/home-manager/options.html

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    #
    # You need to change these to match your username and home directory
    # path:
    #home.username = "$USER";
    #home.homeDirectory = "$HOME";

    # If you use non-standard XDG locations, set these options to the
    # appropriate paths:
    #
    # xdg.cacheHome
    # xdg.configHome
    # xdg.dataHome

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "21.05";


    # Home manager custom details
    programs.home-manager = {
      enable = true;
      path = "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
    };

    # Since we do not install home-manager, you need to let home-manager
    # manage your shell, otherwise it will not be able to add its hooks
    # to your profile.
    programs.bash = {
      enable = true;
    };

    # home.manager.programs.zsh.initExtra = "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
    # home.manager.programs.zsh.    initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";


    home.packages = [
      pkgs.htop
    ];
}