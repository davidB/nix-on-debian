
# docker build -t nix-on-debian:latest .
# docker run -it --rm -v $PWD:/workspace -w /workspace -t nix-on-debian:latest
FROM docker.io/debian:buster-slim

COPY nix-on-debian-prepare.sh .
RUN bash nix-on-debian-prepare.sh

USER ci
ENV USER=ci
ARG NIXPKGS_CONFIG_ALLOW_UNFREE=true
RUN curl -L https://nixos.org/nix/install | sh \
    && mkdir -p $HOME/.nixpkgs \
    && echo "{ allowUnfree = ${NIXPKGS_CONFIG_ALLOW_UNFREE}; }" >${HOME}/.nixpkgs/config.nix

ENV NIX_PROFILES="/nix/var/nix/profiles/default /home/ci/.nix-profile"
ENV NIX_PATH=/home/ci/.nix-defexpr/channels
ENV NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV PATH=/home/ci/.nix-profile/bin:$PATH

# CMD [ "bash", "--login" ]