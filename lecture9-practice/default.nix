with import <nixpkgs> {};

stdenv.mkDerivation {
  src = "./.";
  name = "lecture9";

  shellHook = ''
    ghci Test.hs
  '';

  buildInputs = [
    (haskellPackages.ghcWithPackages (pkgs: with pkgs; [
      random
      async
    ]) )
  ];
}
