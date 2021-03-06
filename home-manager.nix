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
    home.username = "qaqulya";
    home.homeDirectory = "/home/qaqulya";

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

    programs.git = {
      enable = true;
      userName = "fuad-ibrahimzade";
      userEmail = "i.fuad.tm@gmail.com";
      extraConfig.pull.rebase = false;
    };

    programs.bash = {
      enable = true;
    };

    programs.fish = {
      enable = true;

      plugins = [{
          name="foreign-env";
          src = pkgs.fetchFromGitHub {
              owner = "oh-my-fish";
              repo = "plugin-foreign-env";
              rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
              sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
          };
      }];

      # TODO
      shellInit =
      ''
          # https://www.lafuente.me/posts/installing-home-manager/
          # fishPlugins.foreign-env
          if status is-interactive 
          and not set -q TMUX
              set -g TMUX tmux new-session -d -s base
              eval $TMUX
              tmux attach-session -d -t base
          end

          if test -e ~/.config/fish/conf.d/nix-env.fish
              curl https://raw.githubusercontent.com/lilyball/nix-env.fish/master/conf.d/nix-env.fish -s -o ~/.config/fish/conf.d/nix-env.fish
          end

          # nix
          if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
              fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          end


          # home-manager fix old
          # if not test -e ~/.bashrc
          #   echo "export NIX_PATH=\$HOME/.nix-defexpr/channels\''\${NIX_PATH:''\+:}\$NIX_PATH" > ~/.bashrc
          #   echo "export LOCALE_ARCHIVE=\"\$HOME/.nix-profile/lib/locale/locale-archive\"" > ~/.bashrc
          #   # echo "export LOCALE_ARCHIVE=\"\$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive\"" > ~/.bashrc
          # end
          # fenv source ~/.bashrc

          # home-manager fix current
          set -gx EDITOR vim
          set -gx VISUAL vim
          set fish_function_path $fish_function_path ~/plugin-foreign-env/functions
          if test -e ~/.nix-profile/etc/profile.d/nix.sh
            fenv source ~/.nix-profile/etc/profile.d/nix.sh
          end
          if test -e ~/.nix-profile/etc/profile.d/hm-session-vars.sh
            fenv source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
          end
      '';

      promptInit = ''
        any-nix-shell fish --info-right | source
      '';
    };

    # home.manager.programs.zsh.initExtra = "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
    # home.manager.programs.zsh.    initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";


    home.packages = [
      pkgs.htop
      pkgs.tmux
      pkgs.wget
      pkgs.curl
      # pkgs.glibcLocales
      pkgs.any-nix-shell
      pkgs.home-manager
    ];
}