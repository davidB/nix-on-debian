# nix-on-debian

A OCI / Docker image to be able to run `nix-shell` (or other nix tool) over a debian image (and not a nixos image).

## Sample usage

### local

```sh
# docker build -t nix-on-debian:latest .
docker run -it --rm -v $PWD:/workspace -w /workspace -t davidb31/nix-on-debian:latest

# inside container
# create add-hox nodejs env and run `node --version` inside
nix-shell -p nodejs --run 'node --version'
exit
```

### CI

1. setup a `shell.nix` into your project
2. configure your ci to use the current image and then to run the shell command `nix-shell --run 'build_my_stuff'`

Into a github-actions it will looks like:

```yaml
name: ci

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    container: davidb31/nix-on-debian:latest
    steps:
      - uses: actions/checkout@v1
      - name: First run of nix-shell to measure download time
        run: nix-shell --run 'echo load shell'
      - name: lint and test
        run: nix-shell --run 'bazelisk test //...'
      - name: demo of multi-line command
        run: |
            nix-shell --run '
                echo "command 1"
                echo "command 2"
            '
```

see folder [/examples](https://github.com/davidB/nix-on-debian/blob/main/examples) and [.github/workflows/examples.yaml]([.github/workflows/examples.yaml](https://github.com/davidB/nix-on-debian/blob/main/.github/workflows/examples.yaml))

### local + CI

Other how to reproduce and debug CI locally.

### To specify a package version with nixpkgs

Please note there is two components nix and nixos with their own versions. For instance nix has the version 2.13.2 and nixos 22.11
More on the current version on the download page of nixos [https://nixos.org/download.html](https://nixos.org/download.html)

To find a package with a specific version use this website [https://lazamar.co.uk/nix-versions/](https://lazamar.co.uk/nix-versions/).
In this example we will use nixos 22.11. Enter a package name and select a revision. You will have some example as

```sh
nix-env -iA git-lfs -f https://github.com/NixOS/nixpkgs/archive/7d7622909a38a46415dd146ec046fdc0f3309f44.tar.gz
```

to add to your CI.

You can use the command 

```sh
nix-env -qP --available git-lfs
```

to get some inside to with version is associated the latest version of a package.


// TODO

## TODO

- [ ] reduce size
- [x] avoid need to "bash --login" to load nix setup defined into `$HOME/.profile`
- [ ] provide doc, more instructions,...
