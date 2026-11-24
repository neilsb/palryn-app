{
  description = "Prebuilt Palryn for x86-64 Linux";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { nixpkgs, ... }: import ./outputs.nix {
    inherit nixpkgs;
    release = builtins.fromJSON (builtins.readFile ./release.json);
  };
}
