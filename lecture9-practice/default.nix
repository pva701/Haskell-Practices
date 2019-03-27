with import <nixpkgs> {};

stdenv.mkDerivation {
  src = "./.";
  name = "lecture9";

  shellHook = ''
    ghci
  '';

  buildInputs = [
    (haskellPackages.ghcWithPackages (pkgs: with pkgs; [
      random
      async
      parallel
    ]) )
  ];
}
