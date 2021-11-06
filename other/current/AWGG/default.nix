with import <nixpkgs> { };

let 
  myShell = mkShell rec {
    # include any libraries or programs in buildInputs
    buildInputs = [
      qtpass
      gcc
      #lazarus
      #lazarus-qt
    ];
  
    # shell commands to be ran upon entering shell
    shellHook = ''
    '';
  };
  myDrv = pkgs.stdenv.mkDerivation {
    name = "AWGG";
    buildInputs = [
      which
      binutils
   
      xorg.libX11
      pkg-config

      qtpass
      gcc
      #lazarus
      #lazarus-qt
      #fpc
      libqt5pas
      curl aria2 youtube-dl axel
      autoPatchelfHook # Automatically setup the loader, and do the magic
    ];
    propogatedBuildInputs = [
      curl aria2 youtube-dl axel
    ];
    nativeBuildInputs = with pkgs;[
      autoPatchelfHook # Automatically setup the loader, and do the magic
      makeWrapper
    ];
    src = ./.;
    #dontUnpack = true;
    unpackPhase = ":";
    installPhase = ''
      mkdir -p $out/bin
      cp $src/awgg $out/bin/.
    '';
    preFixup = ''
      #wrapProgram $out/bin/awgg --prefix PATH : ${lib.makeBinPath [ curl aria2 youtube-dl axel ]}
      wrapProgram $out/bin/awgg --prefix AWGG_PATH : "$out/bin"
    '';
    #AWGG_PATH="$out/bin";
  };
  mergedDrv = pkgs.symlinkJoin {
    name ="merged-package";
    paths = with pkgs; [ curl aria2 youtube-dl axel myDrv.out ];
  };

  myEnv = pkgs.buildEnv {
    name = "myEnv";
    paths = with pkgs; [ which pkg-config curl aria2 youtube-dl axel myDrv ];
  };

  myFhs = pkgs.buildFHSUserEnv {
    name = "my-python-env";
    targetPkgs = pkgs: with pkgs; [
      #python38Full
      
      #python3Packages.pipenv
      #python38Packages.poetry
      which
      gcc
      binutils
   
      ## All the C libraries that a manylinux_1 wheel might depend on:
      #ncurses
      xorg.libX11
      #xorg.libXext
      #xorg.libXrender
      #xorg.libICE
      #xorg.libSM
      #glib
      #glib.dev
  
      ##pkgconfig
      #readline
      #cmake
      #dbus
      #dbus.dev
      #libdbusmenu
      pkg-config
 
      ##mydrv
      ##mySetupHook
      #dbus-glib
      #pkgs.meson pkgs.vala 
      #pkgs.gtk3 
      #pkgs.gtk2 
      #pkgs.libwnck3 pkgs.bamf pkgs.git
      #pkgs.xfce.xfconf
      #pkgs.xfce.xfce4-panel
      #pkgs.ninja

      qtpass
      gcc
      #lazarus
      #lazarus-qt
      #fpc
      libqt5pas
      curl aria2 youtube-dl
 
    ];
    #nativeBuildInputs = with pkgs;[
    #  autoPatchelfHook # Automatically setup the loader, and do the magic
    #];
   
    runScript = "zsh";
    profile=''
      echo $SHELL
      #SOURCE_DATE_EPOCH=$(date +%s)
      
 
      #export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(nix eval --raw nixpkgs.dbus)/lib64:$(nix eval --raw nixpkgs.readline)/lib:$(nix eval --raw nixpkgs.glib)/lib
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(nix eval --raw nixpkgs.qtpass)/lib64:$(nix eval --raw nixpkgs.readline)/lib:$(nix eval --raw nixpkgs.glib)/lib
    '';
  };
in
  #myFhs.env
  #myFhs
  myDrv
  #mergedDrv
  #myEnv
