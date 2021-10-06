# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  your_hostid = pkgs.writeShellScriptBin "your_hostid" ''
    echo $(head -c 8 /etc/machine-id)
  '';
  main_user = pkgs.writeShellScriptBin "main_user" ''
    read -r -p "User Name (default: user):" user_name;
    user_name=user_name;
  '';
  home-manager= builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager.git";
    ref = "release-21.05";
  };
  
  #home-manager = (import ./home-manager.nix).home-manager;  
  comma = builtins.fetchTarball {
    url = "https://github.com/Shopify/comma/archive/refs/tags/1.0.0.tar.gz";
  };

  graphanix = builtins.fetchTarball {
    url = "https://github.com/stolyaroleh/grafanix/archive/refs/tags/v0.2.tar.gz";
  };

  custom-scripts = (import "/etc/nixos/custom-scripts");

in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./home-manager.nix
    (import "${home-manager}/nixos")
    #(import "${custom-scripts}/")
  ] 
    ++ (if builtins.pathExists ./cachix.nix then [ ./cachix.nix ] else []);
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Or Use GRUB EFI boot loader.
  # boot.loader.efi.canTouchEfiVariables = false;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.devices = [ "nodev" ];
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.useOSProber = true;

  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  # networking.networkmanager.unmanaged = [
  #   "*" "except:type:wwan" "except:type:gsm"
  # ]; #for not conflicting with wpa_supplicant
   programs.nm-applet.enable = true;

  # Add ZFS support.
  boot.kernelParams = ["zfs.zfs_arc_max=12884901888"];
  boot.initrd.supportedFilesystems = ["zfs"];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.tmpOnTmpfs = true;

  networking.hostId = "700489c6";
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.wireless.networks.your_wifiname.pskRaw = "your_pskRaw_generated";
  # networking.wireless.networks.your_wifiname.hidden = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = false; #to fix long nixos boot on dhcpd client
  networking.interfaces.enp0s26u1u2i6.useDHCP = false; #to fix long nixos boot on dhcpd client
  # networking.interfaces.wlo1.useDHCP = true; #to fix long nixos boot on dhcpd client change to wlan0
  networking.interfaces.wlan0.useDHCP = true;

  systemd.services.systemd-udev-settle.enable = false; #to fix long nixos boot on dhcpd client

  # Set your time zone.
  time.timeZone = "Asia/Baku";

  # List services that you want to enable:
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.xserver.layout = "us,ru,az";
   # services.xserver.xkbOptions = "eurosign:e";
   #services.xserver.xkbVariant = "workman,";
   #services.xserver.xkbVariant = "alt-intl,";
   services.xserver.xkbOptions = "grp:win_space_toggle";


  # Enable touchpad support.
   services.xserver.libinput.enable = true;

  # Enable Lumina desktop Environment
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.lumina.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;
  #services.xserver.desktopManager.mate.enable = true;
  services.compton = {
    enable = true;
    shadow = true;
    activeOpacity = 0.9;
    inactiveOpacity = 0.6;
    # backend = "glx";
    # vSync = "opengl-swc";
    # paintOnOverlay = true;
  };

  systemd.user.services."urxvtd" = {
    enable = true;
    description = "rxvt unicode daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt_unicode ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -o";
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      #anonymousPro
      #corefonts
      dejavu_fonts
      #noto-fonts
      #freefont_ttf
      #google-fonts
      #inconsolata
      #liberation_ttf
      powerline-fonts
      #source-code-pro
      terminus_font
      #ttf_bitstream_vera
      #ubuntu_font_family
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Meslo" ]; })

    ];
  };

  #services.xserver.displayManager.sessionCommands =  ''
       #xrdb "${pkgs.writeText  "xrdb.conf" ''
          #URxvt.font:                 xft:Dejavu Sans Mono for Powerline:size=11
          #XTerm*faceName:             xft:Dejavu Sans Mono for Powerline:size=11
          #XTerm*utf8:                 2
          #URxvt.iconFile:             /usr/share/icons/elementary/apps/24/terminal.svg
          #URxvt.letterSpace:          0
          #URxvt.background:           #121214
          #URxvt.foreground:           #FFFFFF
          #XTerm*background:           #121212
          #XTerm*foreground:           #FFFFFF
          #! black
          #URxvt.color0  :             #2E3436
          #URxvt.color8  :             #555753
          #XTerm*color0  :             #2E3436
          #XTerm*color8  :             #555753
          #! red
          #URxvt.color1  :             #CC0000
          #URxvt.color9  :             #EF2929
          #XTerm*color1  :             #CC0000
          #XTerm*color9  :             #EF2929
          #! green
          #URxvt.color2  :             #4E9A06
          #URxvt.color10 :             #8AE234
          #XTerm*color2  :             #4E9A06
          #XTerm*color10 :             #8AE234
          #! yellow
          #URxvt.color3  :             #C4A000
          #URxvt.color11 :             #FCE94F
          #XTerm*color3  :             #C4A000
          #XTerm*color11 :             #FCE94F
          #! blue
          #URxvt.color4  :             #3465A4
          #URxvt.color12 :             #729FCF
          #XTerm*color4  :             #3465A4
          #XTerm*color12 :             #729FCF
          #! magenta
          #URxvt.color5  :             #75507B
          #URxvt.color13 :             #AD7FA8
          #XTerm*color5  :             #75507B
          #XTerm*color13 :             #AD7FA8
          #! cyan
          #URxvt.color6  :             #06989A
          #URxvt.color14 :             #34E2E2
          #XTerm*color6  :             #06989A
          #XTerm*color14 :             #34E2E2
          #! white
          #URxvt.color7  :             #D3D7CF
          #URxvt.color15 :             #EEEEEC
          #XTerm*color7  :             #D3D7CF
          #XTerm*color15 :             #EEEEEC
          #URxvt*saveLines:            32767
          #XTerm*saveLines:            32767
          #URxvt.colorUL:              #AED210
          #URxvt.perl-ext:             default,url-select
          #URxvt.keysym.M-u:           perl:url-select:select_next
          #URxvt.url-select.launcher:  /usr/bin/firefox -new-tab
          #URxvt.url-select.underline: true
          #Xft*dpi:                    96
          #Xft*antialias:              true
          #Xft*hinting:                full
          #URxvt.scrollBar:            false
          #URxvt*scrollTtyKeypress:    true
          #URxvt*scrollTtyOutput:      false
          #URxvt*scrollWithBuffer:     false
          #URxvt*scrollstyle:          plain
          #URxvt*secondaryScroll:      true
          #Xft.autohint: 0
          #Xft.lcdfilter:  lcddefault
          #Xft.hintstyle:  hintfull
          #Xft.hinting: 1
          #Xft.antialias: 1 
       #''}"
    #'';
 
  services.xserver.displayManager.defaultSession = "lxqt+i3";
  #services.xserver.videoDrivers = [ "modesetting" ];
  #services.xserver.useGlamor = true;

  #services.xserver.videoDrivers = [ "intel" ];
  #services.xserver.deviceSection = ''
  #  Option "DRI" "2"
  #  Option "TearFree" "true"
  #'';
  # services.xserver.windowManager.exwm.enable = true

  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "/home/qaqulya/.config/background-image/nixos.png";
 };
  #services.xserver.displayManager.defaultSession = "none+notion";
  
  #services.xserver.windowManager.notion.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  programs.dconf.enable = true;

  # services.xserver.displayManager.xpra = true
  # services.xserver.displayManager.startx.enable = true;

  # ZFS services
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  # ZSH shell
  # programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  #users.users.qaqulya.shell = pkgs.fish;
  users.users.qaqulya.shell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ 
        "colored-man-pages"
        "themes"
        "vi-mode"
        "vscode"
        "git" 
        "thefuck" 
	"history-substring-search"
	"fzf"
      ];
      theme = "robbyrussell";
    };
    histSize = 10000;
    histFile = "/home/qaqulya/.local/share/zsh/history";
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
  };

programs.zsh.interactiveShellInit = ''
   #export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
   export FZF_BASE=${pkgs.fzf}/share/fzf/
   ## Customize your oh-my-zsh options here
   #ZSH_THEME="robbyrussell"
   #plugins=(git fzf )
   #HISTFILESIZE=500000
   #HISTSIZE=500000
   #setopt SHARE_HISTORY
   #setopt HIST_IGNORE_ALL_DUPS
   #setopt HIST_IGNORE_DUPS
   #setopt INC_APPEND_HISTORY
   #autoload -U compinit && compinit
   #unsetopt menu_complete
   #setopt completealiases

  #alias tmux="TERM=screen-256color-bce tmux"
  alias matchNixShell="nix-shell -p '(callPackage (fetchTarball https://github.com/DavHau/mach-nix/tarball/3.3.0) {}).mach-nix'
"

  #if [[ $- == *i* && ! -v TMUX ]]; then
  if [[ -o interactive && ! -v TMUX ]]; then 
    session_base="base"
    session_suffix="$(uuidgen)"
    session="base_$(uuidgen)"
    tmux has-session -t $session 2>/dev/null
    if [ $? != 0 ]; then
      #export TMUX="tmux new-session -d -s $session"
      $eval $TMUX
      tmux attach -t "$session" || tmux new -s "$session"; exit
    fi
    #tmux attach-session -d -t $session
   fi

   #if which tmux 2>&1 >/dev/null; then
     #if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
         #tmux attach -t hack || tmux new -s hack; exit
     #fi
   #fi

   #_TRAPEXIT() {
   #   tmux kill-session;
   #}
   #trap _TRAPEXIT EXIT
   if [[ ! -f ~/.zlogout ]]; then
     echo "tmux kill-session" >>  ~/.zlogout
   fi

   addPath(){
    newpath="$1"
    export PATH=$PATH:$newpath
   }

   removeFromPath() {
    local p d
    p=":$1:"
    d=":$PATH:"
    d="''\${d//''\$p/:}"
    d="''\${d/#:/}"
    export PATH="''\${d/%:/}"
   }

   deleteOnlyOldGenerationConfigs() {
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
    # nix-collect-garbage -d
    ## Remove entries from /boot/loader/entries:
    currentgen=$(sudo nix-env -p /nix/var/nix/profiles/system --list-generations | grep current | awk 'print $1')
    sudo bash -c "cd /boot/loader/entries; ls | grep -v $currentgen | xargs rm"
   }

   bindkey '^[[A' history-substring-search-up
   bindkey '^[[B' history-substring-search-down
#
   #if [ -f ~/.aliases ]; then
     #source ~/.aliases
   #fi
#
   #source $ZSH/oh-my-zsh.sh
   #export LD_LIBRARY_PATH=$(nix eval --raw nixpkgs.zlib)/lib:$LD_LIBRARY_PATH
   export LD_LIBRARY_PATH=$(nix eval --raw nixpkgs.xorg.libX11)/lib:$(nix eval --raw nixpkgs.libsForQt5.libdbusmenu)/lib:$(nix eval --raw nixpkgs.libdbusmenu-gtk3)/lib:$(nix eval --raw nixpkgs.libdbusmenu-gtk2)/lib:$(nix eval --raw nixpkgs.libsForQt5.full)/lib:$LD_LIBRARY_PATH

 '';
 programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  programs.ssh.startAgent = true;
  programs.command-not-found.enable = true;


  environment.systemPackages = with pkgs; [
    nox nix-du graphviz nix-index nixpkgs-fmt  
    gnutar
    (callPackage "${comma}/default.nix" {})
    sqlite
    #(callPackage "${graphanix}/default.nix" {})
    any-nix-shell steam-run steam-run-native direnv nix-bundle
    wget curl vim git rsync htop micro fd tmux lynx ncdu snapper
    trash-cli thefuck aria2 shellcheck fbcat p7zip
    handlr copyq feh rofi vimHugeX #for gvim  
    #haskellPackages.greenclip
    i3lock-fancy xxkb
    #(callPackage "/etc/nixos/custom-scripts/default.nix" {})
    custom-scripts
    libsForQt5.qtstyleplugin-kvantum flat-remix-gtk flat-remix-icon-theme glib
    alacritty kitty st rxvt_unicode
    oh-my-zsh zsh-history-substring-search zsh-powerlevel10k
    #dbus
    #libdbusmenu
    #libdbusmenu_qt
    #libdbusmenu-gtk3
    #libdbusmenu_gtk2
    #libsForQt5.libdbusmenu
    #libsForQt5.full
    #cmake dmenu
    # fishPlugins.foreign-env
    # glibcLocales
    #home-manager
    #python38Full python38Packages.pip python38Packages.poetry
    # xorg.libX11
  ];

 
  environment.variables = { EDITOR = "vim"; };

  # Home Manager initial details
  #home-manager.environment = config.environment;
  home-manager.users.qaqulya = (import ./home-manager.nix);

  # TODO
  # https://nixos.wiki/wiki/Nix_Cookbook
  # https://news.ycombinator.com/item?id=27138939
  # https://github.com/cachix/cachix/issues/259
  # https://cinnamon-spices.linuxmint.com/extensions/view/76
  # https://github.com/fuhsjr00/bug.n
  system.userActivationScripts.home-manager-setup = { 
    text = ''

    # optionally check if the current user id is the one of tomato, as this runs for every user
    # nix-shell https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz -A install
    # nix-shell -p nix-prefetch-url --run ' nix-prefetch-url --unpack https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz ' -A intall
    # nix-env -i -f https://github.com/dustinlacewell/home-manager-helper/archive/master.tar.gz
    # hm

    echo a
    # nix-env -i -f https://github.com/Shopify/comma/archive/refs/tags/1.0.0.tar.gz #comma run without installing
    # , cowsay neato

    # ${pkgs.git}/bin/git clone https://github.com/user/repo ~/location

    # optionally git pull to keep them up to date

    '';
    deps = [];
  };

  # https://nixos.wiki/wiki/IBus
  # https://photonsphere.org/posts/2020-02-19-nixos-configuration.html
  # fish locale fixes
  i18n = {
    #consoleFont = "Lat2-Terminus16";
    #consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_MESSAGES = "en_US.UTF-8"; LC_TIME = "az_AZ"; };
    glibcLocales = lib.hiPrio (pkgs.buildPackages.glibcLocales.override {
      allLocales = lib.any (x: x == "all") config.i18n.supportedLocales;
      locales = config.i18n.supportedLocales;
    });
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  nix.nixPath=[
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # nix.nixPath=[
  #   "nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/21.05.tar.gz"
  #   "nixos-config=/etc/nixos/configuration.nix"
  # ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.mutableUsers = false;
  users.users.qaqulya = {
    isNormalUser = true;
    createHome = true;
    home = "/home/qaqulya";
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    # shell = pkgs.fish;
  };
  # users.users.root.hashedPassword = "!";

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.

#   nix.gc.automatic = true;
  nix.autoOptimiseStore = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
  nix.gc.dates = "20:15";
  # system.autoUpgrade.enable = true;
  system.stateVersion = "21.05"; # Did you read the comment?


}
