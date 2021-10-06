{ config, pkgs, ... }:
let
  #comma = builtins.fetchTarball {
  #  url = "https://github.com/Shopify/comma/archive/refs/tags/1.0.0.tar.gz";
  #};
  #comma= builtins.fetchGit {
  #  url = "https://github.com/Shopify/comma.git";
  #  ref = "1.0.0";
  #};
  my-python-packages = python-packages: with python-packages; [
    pip 
    poetry
    dbus-python 
    pygobject3 
    pygobject2
    # other python packages you want
  ]; 
  python-with-my-packages = pkgs.python38Full.withPackages my-python-packages; 
  mach-nix=(pkgs.callPackage (fetchTarball https://github.com/DavHau/mach-nix/tarball/3.3.0) {}).mach-nix;

in
{
   
   #imports = [
   #  (import "${comma}/")
   #];
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

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 
        #vim-airline
	vim-colorschemes
        vim-nix
        vim-addon-nix
        YouCompleteMe
    ];
    settings = { ignorecase = true; };
    extraConfig = ''
      " set mouse=a
      syntax on
      inoremap <C-s> <esc>:w<cr>                 " save files2 nnoremap <C-s> :w<cr> 
      inoremap <C-d> <esc>:wq!<cr>               " save and exit
      nnoremap <C-d> :wq!<cr>
      inoremap <C-q> <esc>:qa!<cr>               " quit discarding changes
      nnoremap <C-q> :qa!<cr>
      " FIX: ssh from wsl starting with REPLACE mode
      " https://stackoverflow.com/a/11940894
      if $TERM =~ 'xterm-256color'
          set noek
      endif
      :set number relativenumber
      set nocompatible
      
      set background=dark
      set termguicolors
      let g:quantum_black=1
      colorscheme quantum
      " :hi Visual term=reverse cterm=reverse guibg=Grey
      " highlight Visual cterm=bold ctermbg=Blue ctermfg=NONE

      "Remove all trailing whitespace by pressing F5
      "nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

      nnoremap <F5> <esc>:%s/\s\+$//e<cr>
    '';
  };

    #services.lorri.enable = true;
    programs.direnv.enable = true;
    programs.direnv.enableZshIntegration = true;
    programs.direnv.nix-direnv.enable = true;
    # optional for nix flakes support
    programs.direnv.nix-direnv.enableFlakes = true;
  

    programs.vscode.enable = true;
    programs.vscode.package = pkgs.vscode-fhs;

    # home.manager.programs.zsh.initExtra = "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh";
    # home.manager.programs.zsh.    initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    programs.zsh.profileExtra = ''
      if [ -n "$GTK_MODULES" ]
      then
        GTK_MODULES="$GTK_MODULES:unity-gtk-module"
      else
        GTK_MODULES="unity-gtk-module"
      fi
      
      if [ -z "$UBUNTU_MENUPROXY" ]
      then
        UBUNTU_MENUPROXY=1
      fi
    '';


    programs.chromium = {
      enable = true;
      extensions = [
        #"annfbnbieaamhaimclajlajpijgkdblo"
        "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        "eimadpbcbfnmbkopoojfekhnkhdbieeh"
        "fnaicdffflnofjppbagibeoednhnbjhg"
        "gcbommkclmclpchllfjekcdonpmejbdp"
        "hfjbmagddngcpeloejdejnfgbamkjaeg"
        "aapbdbdomjkkjkaonfhkkikfgjllcleb"
        "ldgfbffkinooeloadekpmfoklnobpien"
        "nmhnlemdhjjebiklhbjmpkiekgjjbnfc"
        "dojjmigcfgjcjakkdhmnkcjajbjcjnja"
      ]; 
    };

    nixpkgs.config.allowUnfree = true;

    home.packages = [
      # pkgs.glibcLocales
       # pkgs.fishPlugins.foreign-env
       pkgs.home-manager
       pkgs.qutebrowser
       pkgs.calibre
       pkgs.python38Full mach-nix 
       pkgs.python38Packages.pip pkgs.python38Packages.poetry
       #python-with-my-packages
       pkgs.dotnet-sdk_5
       #pkgs.dotnet-sdk_3
       #pkgs.dotnet-sdk
       pkgs.nodejs

       #python38Packages.dbus-python python38Packages.pygobject3 python38Packages.pygobject2
       pkgs.libdbusmenu
       pkgs.libdbusmenu_qt
       pkgs.libsForQt5.libdbusmenu
       pkgs.libsForQt5.full
       #pkgs.libdbusmenu-gtk3
       #pkgs.libdbusmenu-gtk2

       pkgs.libsForQt5.qt5.qttools
       pkgs.dfeet
       pkgs.bustle
    ];
}

