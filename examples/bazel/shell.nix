# { pkgs ? import (builtins.fetchTarball {
#   # Descriptive name to make the store path easier to identify
#   name = "nixpkgs-unstable-2021-05-15";
#   # Commit hash for nixpkgs-unstable as of 2021-05-15 from https://status.nixos.org/
#   url = "https://github.com/nixos/nixpkgs/archive/a2c3ea5bf825.tar.gz";
#   # Hash obtained using `nix-prefetch-url --unpack <url>`
#   sha256 = "0rxn9wg73gvgb7zwzrdhranlj3jpkkcnsqmrzw5m0znwv6apj6k4";
# }) {}}:
{ pkgs ? import <nixpkgs> {}}:

with pkgs;
mkShell {                  # mkShell is a helper function
  name="dev-environment";       # that requires a name
  nativeBuildInputs = [    # for a list of packages (search https://search.nixos.org/packages)
    nix-info
    bazelisk
    bazel-buildtools
  ];
  shellHook = ''             # bash to run when you enter the shell
    
  '';
}