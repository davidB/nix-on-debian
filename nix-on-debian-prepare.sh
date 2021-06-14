#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get full-upgrade -y
apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    locales \
    sudo \
    xz-utils

localedef -f UTF-8 -i en_US -A /usr/share/locale/locale.alias -c en_US.UTF-8

groupadd -g 30000 --system nixbld

for i in $(seq 1 32); do
    useradd \
        --home-dir /var/empty \
        --gid 30000 \
        --groups nixbld \
        --no-user-group \
        --system \
        --shell /usr/sbin/nologin \
        --uid $((30000 + i)) \
        --password "!" \
        nixbld$i
done

mkdir -p \
    /root/.config/nix \
    /root/.nixpkgs
mv /tmp/nix.conf /root/.config/nix/nix.conf
echo "{ allowUnfree = ${NIXPKGS_CONFIG_ALLOW_UNFREE}; }" >/root/.nixpkgs/config.nix

cd /tmp
curl -Ls https://nixos.org/releases/nix/nix-${NIXPKGS_VERSION}/nix-${NIXPKGS_VERSION}-x86_64-linux.tar.xz | tar xJf -
cd nix-${NIXPKGS_VERSION}-x86_64-linux
USER=root ./install --no-daemon

export NIX_PATH=nixpkgs=/root/.nix-defexpr/channels/nixpkgs:/root/.nix-defexpr/channels
export NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export PATH=/root/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export SUDO_FORCE_REMOVE=yes

# nix-channel --update
# nix-env -iA \
#     nixpkgs.nix

apt-get purge -y \
    bzip2 \
    curl \
    sudo \
    xz-utils
apt-get autoremove --purge -y
rm -rf /var/lib/apt/lists/*
# nix-channel --remove nixpkgs
# rm -rf /nix/store/*-nixpkgs*
nix-collect-garbage -d
nix-store --verify --check-contents
nix optimise-store
rm -rf /tmp/*
