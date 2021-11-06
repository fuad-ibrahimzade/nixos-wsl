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
  #i3-hud-menu = (pkgs.callPackage "/etc/nixos/i3-hud-menu/default.nix" {});
  i3-hud-menu = (import "/etc/nixos/i3-hud-menu");
  #nixpkgs2009 = import
  #  (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/20.09)
  #  # reuse the current configuration
  #  { config = config.nixpkgs.config; };
  #xfce-with-appmenu = (pkgs.callPackage "/etc/nixos/xfce4-panel-with-appmenu/override-xfce4-panel.nix" {});
  #appmenu-registrar = (pkgs.callPackage "/etc/nixos/xfce4-panel-with-appmenu/appmenu-related/appmenu-registrar.nix" {});
  #appmenu-gtk-module = (pkgs.callPackage "/etc/nixos/xfce4-panel-with-appmenu/appmenu-related/appmenu-gtk-arch.nix" {});
  #vala-appmenu-xfce = (pkgs.callPackage "/etc/nixos/xfce4-panel-with-appmenu/appmenu-related/vala-appmenu-xfce-arch.nix" {});
  #appmenu-gtk-module3 = (pkgs.callPackage "/etc/nixos/custom-scripts/appmenu-gtk-module3.nix" {});
  plasma-i3-session-package = (pkgs.callPackage "/etc/nixos/custom-scripts/plasma-i3.nix" {});
  plasma-hud = (pkgs.callPackage "/etc/nixos/plasma-hud/default.nix" {});
  motrix = (pkgs.callPackage "/etc/nixos/motrix/default.nix" {});
  #awgg-download-manager = (pkgs.callPackage "/etc/nixos/AWGG/default.nix" {});
  awgg-download-manager = (import "/etc/nixos/AWGG/default.nix");
    
in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./home-manager.nix
    (import "${home-manager}/nixos")
    #(import "${custom-scripts}/")
    /etc/nixos/custom-scripts/virtualisation-unstable.nix
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

  #for dual booting grub windows
  #boot.loader = {
    #efi = {
      #canTouchEfiVariables = true;
      ## assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      #efiSysMountPoint = "/boot";
    #};
    #grub = {
      ## despite what the configuration.nix manpage seems to indicate,
      ## as of release 17.09, setting device to "nodev" will still call
      ## `grub-install` if efiSupport is true
      ## (the devices list is not used by the EFI grub install,
      ## but must be set to some value in order to pass an assert in grub.nix)
      #devices = [ "nodev" ];
      ##device = "/dev/sda";
      #efiSupport = true;
      #enable = true;
      ## set $FS_UUID to the UUID of the EFI partition
      ##extraEntries = ''
        ##menuentry "Windows" {
          ##insmod part_gpt
          ##insmod fat
          ##insmod search_fs_uuid
          ##insmod chain
          ##search --fs-uuid --set=root $FS_UUID
          ##chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        ##}
      ##'';
      #version = 2;
      #useOSProber = true;
    #};
  #};
  #time.hardwareClockInLocalTime = true;


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
  #services.xserver.desktopManager.lxqt.enable = true;
  #services.xserver.desktopManager.mate.enable = true;
  #services.xserver.desktopManager.xfce = {
  #  enable = true;
  #  #noDesktop = true;
  #  #enableXfwm = false;
  #};
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  #services.xserver.displayManager.defaultSession = "plasma5";
  services.xserver.displayManager.defaultSession = "plasma-i3";
  services.xserver.displayManager.sessionPackages = [ plasma-i3-session-package ];




  #services.compton = {
    #enable = true;
    #shadow = true;
    #activeOpacity = 0.9;
    #inactiveOpacity = 0.6;
    ## backend = "glx";
    ## vSync = "opengl-swc";
    ## paintOnOverlay = true;
    #opacityRules = [ 
      #"100:name = 'jgmenu'"
      #"100:class_g = 'dmenu'"
    #];
  #};

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
 
  #services.xserver.displayManager.defaultSession = "lxqt+i3";
  #services.xserver.displayManager.defaultSession = "xfce";
  
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  #environment.gnome.excludePackages = [
  #  pkgs.mbrola
  #  pkgs.espeak-ng
  #  pkgs.orca
  #  pkgs.speechd
    #pkgs.xfce.xfdesktop
  #];



  
  #services.xserver.videoDrivers = [ "modesetting" ];
  #services.xserver.useGlamor = true;

  #services.xserver.videoDrivers = [ "intel" ];
  #services.xserver.deviceSection = ''
  #  Option "DRI" "2"
  #  Option "TearFree" "true"
  #'';
  # services.xserver.windowManager.exwm.enable = true

  #services.xserver.displayManager.lightdm = {
  #  enable = true;
  #  #background = "/home/qaqulya/.config/background-image/nixos.png";
  #  background = "/home/qaqulya/.config/background-image/nix-wallpaper-stripes-logo.png";
  #};
  #services.xserver.displayManager.lightdm.greeters.gtk.enable= true;
  #services.xserver.displayManager.sddm.enable = true;

  #services.xserver.displayManager.defaultSession = "none+notion";
  
  #services.xserver.windowManager.notion.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  programs.dconf.enable = true;

  # services.xserver.displayManager.xpra = true
  # services.xserver.displayManager.startx.enable = true;

  #virtualisation.libvirtd.enable = true;
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #users.extraGroups.vboxusers.members = [ "qaqulya" ];


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
      rm = "echo Use 'del', or the full path i.e. '/bin/rm'";
      rmTrash= "trash-put";
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
  #alias machNixShell="nix-shell -p '(callPackage (fetchTarball https://github.com/DavHau/mach-nix/tarball/3.3.0) {}).mach-nix'"
  machNixShell() {
    packages="$@"
    mach-nix env ./env -r "$packages";
    nix-shell ./env
  }
  removeMachNixShell() {
    rm ./env
  }

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
   #export LD_LIBRARY_PATH=$(nix eval --raw nixpkgs.xorg.libX11)/lib:$(nix eval --raw nixpkgs.libsForQt5.libdbusmenu)/lib:$(nix eval --raw nixpkgs.libdbusmenu-gtk3)/lib:$(nix eval --raw nixpkgs.libdbusmenu-gtk2)/lib:$(nix eval --raw nixpkgs.libsForQt5.full)/lib:$LD_LIBRARY_PATH
  NIX_LINK=/home/qaqulya/.nix-profile
  export LD_LIBRARY_PATH="$NIX_LINK"/lib:/nix/var/nix/profiles/system/sw/lib:$LD_LIBRARY_PATH

  export KWIN_TRIPLE_BUFFER=1
 
 '';
 programs.zsh.promptInit = ''
   source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
   any-nix-shell zsh --info-right | source /dev/stdin
   #export LD_LIBRARY_PATH=$(nix eval --raw nixpkgs.xorg.libX11)/lib:$(nix eval --raw nixpkgs.libsForQt5.libdbusmenu)/lib:$(nix eval --raw nixpkgs.libdbusmenu-gtk3)/lib:$(nix eval --raw nixpkgs.libdbusmenu-gtk2)/lib:$(nix eval --raw nixpkgs.libsForQt5.full)/lib:$LD_LIBRARY_PATH
   eval "$(direnv hook zsh)"
  '';

  services.gnome.gnome-keyring.enable = true;
  #security.pam.services.lightdm.enableGnomeKeyring = true;
  programs.ssh.startAgent = true;
  programs.command-not-found.enable = true;
  
  environment.pathsToLink = [ "/libexec" ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  programs.partition-manager.enable = true;

  environment.systemPackages = with pkgs; [
    nox nix-du graphviz nix-index nixpkgs-fmt  
    gnutar
    (callPackage "${comma}/default.nix" {})
    sqlite
    #(callPackage "${graphanix}/default.nix" {})
    any-nix-shell steam-run steam-run-native direnv nix-bundle nix-template
    wget curl vim git rsync htop micro fd tmux lynx ncdu snapper
    trash-cli thefuck aria2 shellcheck fbcat p7zip trickle youtube-dl
    handlr copyq feh rofi vimHugeX #for gvim  
    #virt-manager virtualbox
    browsh firefox-bin
    w3m links2
    #uget uget-integrator
    motrix
    awgg-download-manager
    
    #haskellPackages.greenclip
    i3lock-fancy xxkb
    #(callPackage "/etc/nixos/custom-scripts/default.nix" {})
    custom-scripts 
    #xfce-with-appmenu 
    plotinus
    i3-gaps i3-hud-menu
    plasma-hud
    #synapse
    keynav
    at-spi2-atk
    #xfce.xfce4-i3-workspaces-plugin
    kde-gtk-config
    #appmenu-gtk-module3

    #appmenu-registrar appmenu-gtk-module
    #vala-appmenu-xfce
    #xfce.xfce4-battery-plugin
    indicator-application-gtk2
    indicator-application-gtk3
    #nixpkgs2009.xfce.xfce4-vala-panel-appmenu-plugin
    #conky

    libsForQt5.qtstyleplugin-kvantum flat-remix-gtk flat-remix-icon-theme glib
    alacritty kitty st rxvt_unicode
    oh-my-zsh zsh-history-substring-search zsh-powerlevel10k
    #dbus
    libdbusmenu
    libdbusmenu_qt
    libdbusmenu-gtk3
    libdbusmenu-gtk2
    libsForQt5.libdbusmenu
    #libsForQt5.full
    libsForQt5.krunner
    libsForQt5.discover
    libsForQt5.ark
    libsForQt5.plasma-browser-integration
    #cmake 
    dmenu 
    #haskellPackages.dmenu
    #haskellPackages.dmenu-pkill 
    #haskellPackages.dmenu-search 
    #haskellPackages.yeganesh 
    clipmenu
    jgmenu
    # fishPlugins.foreign-env
    # glibcLocales
    #home-manager
    #python38Full python38Packages.pip python38Packages.poetry
    xorg.libX11
    #indicator-application-gtk2 indicator-application-gtk3
    #gnomeExtensions.appindicator
    darling-dmg
    wineWowPackages.stable appimage-run
    libunity
    apt-offline
  ];

  nix = {
      trustedUsers = [ "root" "qaqulya" ];
      #package = pkgs.nixFlakes;
      #extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      #  "experimental-features = nix-command flakes";
   };

  services.dbus.packages = [ 
    pkgs.gnome.dconf 
  #  #appmenu-registrar 
  #  pkgs.at-spi2-atk 
  ];
  #systemd.packages = [ 
    #appmenu-gtk-module 
    #appmenu-gtk-module3
  #];
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
  services.bamf.enable = true;
  #services.zeitgeist.enable = true;

 
  environment.variables = { 
    EDITOR = "vim"; 
    #XDG_DATA_DIRS = lib.mkOverride 50 "$XDG_DATA_DIRS:${pkgs.plotinus}/share/gsettings-schemas/${pkgs.plotinus.name}";
    #XDG_DATA_DIRS = lib.mkOverride 50 "$XDG_DATA_DIRS:${appmenu-gtk-module3}/share/gsettings-schemas/appmenu-gtk3-module-0.7.6/glib-2.0/schemas";
    XDG_DATA_DIRS = lib.mkOverride 50 "${pkgs.plotinus}/share/gsettings-schemas/${pkgs.plotinus.name}";
    #XDG_DATA_DIRS = lib.mkOverride 50 "${pkgs.plotinus}/share/gsettings-schemas/${pkgs.plotinus.name}/glib-2.0/schemas";
    #GTK3_MODULES = "${pkgs.plotinus}/lib";
    #GTK3_MODULES = "${pkgs.plotinus}/lib/libplotinus.so";
    #GTK3_MODULES = "${pkgs.plotinus}/lib/libplotinus.so";
    #LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.plotinus}/lib:${appmenu-registrar}/lib:${appmenu-gtk-module}/lib";
    #GTK2_MODULES="$GTK_MODULES:appmenu-gtk-module";
    #GTK_MODULES="$GTK_MODULES:${appmenu-gtk-module}/lib/gtk-3.0/modules/libappmenu-gtk-module.so";
    #GTK3_MODULES="$GTK_MODULES:${appmenu-gtk-module}/lib/gtk-3.0/modules/libappmenu-gtk-module.so";
    #GTK2_MODULES="$GTK_MODULES:${appmenu-gtk-module}/lib/gtk-2.0/modules/libappmenu-gtk-module.so";
    #UBUNTU_MENUPROXY="1";
    #UGET_COMMAND = "${pkgs.uget}/bin/uget-gtk";
  };

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
    extraGroups = [ "wheel" "networkmanager" "audio" "libvirtd" ];
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
