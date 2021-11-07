#with import <nixpkgs> {};
let
  pkgs = import <nixpkgs> {};
  lib = pkgs.stdenv.lib;

  myPython = pkgs.python38;
  myDrv = pkgs.stdenv.mkDerivation {  
    name = "torrent2magnet-drv";
    src = ./.;
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin; 
      cp $src/torrent2magnet.py $out/bin/torrent2magnet
      cp $src/torrentinfo.py $out/bin/torrentinfo
      cp -av $src/. $out/bin
      chmod +x $out/bin/torrent2magnet
      chmod +x $out/bin/torrentinfo
    '';
    buildInputs = with pkgs; [
      myPython
    ];
 
  };
in 
  myDrv

