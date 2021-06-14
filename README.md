# nix-on-debian

A OCI / Docker image to be able to run `nix-shell` (or other nix tool) over a debian image (and not a nixos image).

The user inside the image is not root, he is name 'ci' and have 'sudo'.

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

see folder [/examples](.examples) and [.github/workflows/examples.yaml](.github/workflows/examples.yaml)

### local + CI

Other how to reproduce and debug CI locally.

// TODO

## TODO

- [ ] reduce size
- [ ] avoid need to "bash --login" to load nix setup defined into `$HOME/.profile`
- [ ] provide doc, more instructions,...
