with import <nixpkgs> {};
stdenv.mkDerivation {  
  name = "kbi";
  src = ./.;
  phases = ["installPhase"];
  installPhase = "mkdir -p $out/bin; cp $src/kbi $out/bin";
}
