{ pkgs ? (
    let
      sources = import ./nix/sources.nix;
    in
    import sources.nixpkgs {
      overlays = [
        (import "${sources.gomod2nix}/overlay.nix")
      ];
    }
  )
}:

pkgs.buildGoApplication {
  name = "cortile";
  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;
  phases = [ "installPhase" "shellHook" ];
  shellHook = '' 
    export PATH="${<nixpkgs>.cortile}/bin:$PATH"
  '';
  installPhase = ''
    echo "Installing binary"
    install -D $src $out/bin/cortile
    chmod a+x $out/bin/cortile
  '';
}
