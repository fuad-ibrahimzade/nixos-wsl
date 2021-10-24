let
  pkgs = import <nixpkgs> {};
  lib = pkgs.stdenv.lib;
  customPython = (pkgs.python38Full.buildEnv.override {
    extraLibs = with pkgs.python38Packages; [
      dbus-python
      dbus-next
      pycairo
      pygobject3
    ];
  });

#with import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {  
  name = "custom-scripts";
  src = ./.;
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/bin; cp -av $src/. $out/bin
    #uget-integration
    #mkdir -p /etc/chromium/native-messaging-hosts
    #cp "${pkgs.uget-integrator}/etc/chromium/native-messaging-hosts/com.ugetdm.chrome.json" /etc/chromium/native-messaging-hosts/com.ugetdm.chrome.json
  

  '';
  buildInputs = with pkgs; [
    xorg.libX11 # for qmenu
    #libsForQt5.full
    libdbusmenu_qt
    libsForQt5.libdbusmenu
    libdbusmenu-gtk3
    libdbusmenu-gtk2

    libsForQt5.qt5.qttools
    dfeet
    bustle
  ];
  nativeBuildInputs = with pkgs; [
    #customPython
    xorg.libX11
    cairo
    dbus
    libdbusmenu
    libdbusmenu_qt
    libdbusmenu-gtk3
    gtk3
    dbus-glib
    gobject-introspection
  ];
  runtimeDependencies = with pkgs; [
    dbus
    #customPython
    #for motrix
    appimage-run
  ];
  #propagatedNativeBuildInputs = [
  #  customPython
  #];
  #propagatedBuildInputs = [
  #  customPython
  #];
  shellHook = ''
    #export QT_SELECT="qt4"
    #export QTTOOLDIR="${pkgs.qt4}/bin"
    #export QTLIBDIR="${pkgs.qt4}"
    export LD_LIBRARY_PATH="${pkgs.libdbusmenu_qt}/lib:${pkgs.libsForQt5.libdbusmenu}/lib:$LD_LIBRARY_PATH"
    #export DBUSMENUQT="${pkgs.libdbusmenu_qt}"
    #export CMAKE_LIBRARY_PATH="${pkgs.libdbusmenu_qt}/lib:$CMAKE_LIBRARY_PATH"
  '';
 
  #outputs = [
  #  "out"
    #"${pkgs.libsForQt5.libdbusmenu}"
    #"libsForQt5.libdbusmenu"
  #];
  #allowedRequisites = [ pkgs.xorg.libX11 ];
  #LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
  #LD_LIBRARY_PATH="/run/opengl-driver/lib:${pkgs.glfw}/lib";
  LD_LIBRARY_PATH="''\${pkgs.xorg.libX11)/lib:''\${pkgs.libdbusmenu_qt}/lib:''\${pgs.libsForQt5.libdbusmenu}:''\$LD_LIBRARY_PATH";



}
