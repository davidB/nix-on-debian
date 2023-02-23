
# docker build -t nix-on-debian:latest .
# docker run -it --rm -v $PWD:/workspace -w /workspace -t nix-on-debian:latest
FROM docker.io/debian:buster-slim

ARG NIXPKGS_CONFIG_ALLOW_UNFREE=true
ARG NIXPKGS_VERSION=2.13.2

COPY nix-on-debian-prepare.sh .
RUN bash nix-on-debian-prepare.sh


USER root
ENV NIX_PROFILES="/nix/var/nix/profiles/default /root/.nix-profile"
ENV NIX_PATH=/root/.nix-defexpr/channels
ENV NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV PATH=/root/.nix-profile/bin:$PATH

# CMD [ "bash", "--login" ]