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
  
in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./home-manager.nix
    (import "${home-manager}/nixos")
  ] 
    ++ (if builtins.pathExists ./cachix.nix then [ ./cachix.nix ] else []);

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Or Use GRUB EFI boot loader.
  # boot.loader.efi.canTouchEfiVariables = true;
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
  # programs.nm-applet.enable = true;

  # Add ZFS support.
  boot.kernelParams = ["zfs.zfs_arc_max=12884901888"];
  boot.initrd.supportedFilesystems = ["zfs"];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  boot.tmpOnTmpfs = true;

  networking.hostId = your_hostid;
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
   services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
   services.xserver.libinput.enable = true;

  # Enable Lumina desktop Environment
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.lumina.enable = true;
  services.xserver.desktopManager.mate.enable = true;
  services.compton = {
    enable = true;
    shadow = true;
    inactiveOpacity = 0.8;
    # backend = "glx";
    # vSync = "opengl-swc";
    # paintOnOverlay = true;
  };
  # services.xserver.videoDrivers = [ "modesetting" ];
  # services.xserver.useGlamor = true;

  # services.xserver.videoDrivers = [ "intel" ];
  # services.xserver.deviceSection = ''
  #   Option "DRI" "2"
  #   Option "TearFree" "true"
  # '';
  # services.xserver.windowManager.exwm.enable = true

  services.xserver.displayManager.lightdm = {
    enable = true;
    # greeters.mini = {
    #     enable = true;
    #     user = "qaqulya";
    #     extraConfig = ''
    #         [greeter]
    #         show-password-label = true
    #         [greeter-theme]
    #         background-image = ""
    #     '';
    # };
    greeters.tiny = {
        enable = true;
        # extraConfig = ''
        # '';
    };
  };
  services.xserver.displayManager.defaultSession = "none+notion";
  
  services.xserver.windowManager.notion.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  # services.xserver.windowManager.i3.enable = true;
  # services.xserver.windowManager.i3.package = pkgs.i3-gaps;
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
  # users.users.yourname.shell = pkgs.zsh;

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
      ];
      theme = "robbyrussel";
    };
    histSize = 10000;
    histFile = "/home/qaqulya/.local/share/zsh/history";
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
  };


  environment.systemPackages = with pkgs; [
    nox nix-du graphviz
    nixpkgs-fmt
    wget curl vim git rsync
    python38Full python38Packages.pip python38Packages.poetry
    htop micro fd snapper 
    trash-cli thefuck aria2 shellcheck fbcat p7zip
    home-manager gnutar
    zsh-history-substring-search
    # fishPlugins.foreign-env
  ];

  environment.variables = { EDITOR = "vim"; };

  # Home Manager initial details
  # home-manager.environment = config.environment;
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

    # nix-env -i -f https://github.com/Shopify/comma/archive/refs/tags/1.0.0.tar.gz #comma run without installing
    # , cowsay neato

    # ${pkgs.git}/bin/git clone https://github.com/user/repo ~/location

    # optionally git pull to keep them up to date

    '';
    deps = [];
  }

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
