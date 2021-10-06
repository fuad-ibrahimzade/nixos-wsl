#{ lib, python38Packages, python38, pkgs }:
let 
  pkgs = import <nixpkgs> {};
  python38Packages = pkgs.python38Packages;
  python38 = pkgs.python38;
  lib = pkgs.stdenv.lib;
in
#python38Packages.buildPythonApplication rec {
pkgs.stdenv.mkDerivation rec {
  name = "i3-hud-menu";
  #version = "1";

  src = ./.;

  nativeBuildInputs = [ 
    python38Packages.setuptools
    #pkgs.python
    #pkgs.cmake
    python38
    pkgs.makeWrapper
    pkgs.dbus
    pkgs.wrapGAppsHook
  ];

  propagatedBuildInputs = [ 
    #tornado_4 python-daemon 
    pkgs.cairo
    pkgs.gobject-introspection
    pkgs.gtk3
    pkgs.dbus-glib
    #(pkgs.python38.withPackages (
     #ps: [
       #ps.dbus-python 
       #ps.dbus-next
       #ps.pygobject3
       #ps.pycairo
     #]
    #)
    #)
    pkgs.dbus
    pkgs.dbus-glib
    pkgs.libdbusmenu
    pkgs.libdbusmenu_qt
    pkgs.libdbusmenu-gtk3
    #pkgs.python38
    python38
  ];

  python = python38.withPackages (ps : with ps; [ 
    #pybind11 qcelemental numpy pylibefp 
    dbus-next
    dbus-python
    pycairo
    pygobject3
  ]);
  #dontUseCmakeConfigure = true;
  preFixup = ''
      makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
      wrapProgram "$out/bin/i3-appmenu-service" \
        --prefix PYTHONPATH : "${python}/${python.sitePackages}" \
        --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH:${pkgs.gtk3}/lib:${pkgs.gobject-introspection}/lib:${pkgs.libdbusmenu}/lib:${pkgs.libdbusmenu-gtk3}/lib:${pkgs.glib}/lib:${pkgs.dbus-glib}/lib";
      wrapProgram "$out/bin/i3-hud-menu" \
        --prefix PYTHONPATH : "${python}/${python.sitePackages}" \
        --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH:${pkgs.dbus}/lib:${pkgs.libdbusmenu}/lib:${pkgs.libdbusmenu}/lib:${pkgs.libdbusmenu-gtk3}/lib:${pkgs.glib}/lib:${pkgs.dbus-glib}/lib:${pkgs.gcc-unwrapped}/lib";
      
      #wrapProgram "$out/bin/i3-appmenu-service" \
      #  --prefix "PYTHONPATH : ${python}/lib/${python.executable}/site-packages" \
      #wrapProgram "$out/bin/i3-hud-menu" \
      #  --prefix "PYTHONPATH : ${python}/lib/${python.executable}/site-packages" \
 
  '';
  installPhase = ''
    mkdir -p $out/bin; 
    #cp -av $src/. $out/bin
    cp $src/i3-appmenu-service.py $out/bin/i3-appmenu-service
    chmod +x $out/bin/i3-appmenu-service
    cp $src/i3-hud-menu.py $out/bin/i3-hud-menu
    chmod +x $out/bin/i3-hud-menu
    
  '';
 
  shellHook = ''
      export PIP_PREFIX=$(pwd)/_build/pip_packages
      export PYTHONPATH="$PIP_PREFIX/${pkgs.python38.sitePackages}:$PYTHONPATH"
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.python38}/lib:$(nix eval --raw nixpkgs.dbus)/lib:${pkgs.libdbusmenu}/lib:${pkgs.glib}/lib:${pkgs.dbus-glib}/lib:${pkgs.gcc-unwrapped}/lib
      export LIBS=$LIBS:${pkgs.python38}/lib
      export PATH="$PIP_PREFIX/bin:$PATH"
 
  '';

  #meta = with lib; {
  #  ...
  #};
}
