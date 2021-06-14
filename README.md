# nix-on-debian

A OCI / Docker image to be able to run `nix-shell` (or other nix tool) over a debian image (and not a nixos image).

The user inside the image is not root, he is name 'ci' and have 'sudo'.

## Sample usage

### local

```sh
# docker build -t nix-on-debian:latest .
docker run -it --rm -v $PWD:/workspace -w /workspace -t nix-on-debian:latest

# inside container
# create add-hox nodejs env and run `node --version` inside
nix-shell -p nodejs --run 'node --version'
exit
```

### CI

// TODO

### local + CI

Other how to reproduce and debug CI locally

// TODO

## TODO

- [ ] reduce size
- [ ] avoid need to "bash --login" to load nix setup defined into `$HOME/.profile`
- [ ] provide doc, more instructions,...
