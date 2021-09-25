let
  pkgs = import <nixpkgs> {};
  lib = pkgs.stdenv.lib;
#with import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {  
  name = "custom-scripts";
  src = ./.;
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/bin; cp -av $src/. $out/bin
    
  '';
  buildInputs = with pkgs; [
    xorg.libX11 # for qmenu
  ];
  #allowedRequisites = [ pkgs.xorg.libX11 ];
  #LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
  #LD_LIBRARY_PATH="/run/opengl-driver/lib:${pkgs.glfw}/lib";
  LD_LIBRARY_PATH="''\${pkgs.xorg.libX11)/lib:''\$LD_LIBRARY_PATH";


}
