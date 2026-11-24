{ nixpkgs, release }:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "palryn";
  };
  palryn = import ./package.nix { inherit pkgs release; };
in {
  packages.${system} = { inherit palryn; default = palryn; };
}
