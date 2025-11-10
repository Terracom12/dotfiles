#!/usr/bin/env bash

set -euo pipefail

if ! command -v gpg &>/dev/null; then
    >&2 echo 'gpg is not installed'
    exit 1
fi

read -rp 'Would you like to generate a gpg key? [Y/n] '

if ! [[ $REPLY =~ [Yy] ]]; then
    exit
fi

name="$(git config user.name)"
echo "'$name' is your name from git"
read -rp "If this is correct, press enter; otherwise type your full name: "
if [[ -n $REPLY ]]; then
    name="$REPLY"
    echo "New name is '$name'"
fi

expires=4m
read -rp "Key should expire in [default $expires] "
if [[ -n $REPLY ]]; then
    expires="$REPLY"
    echo "Will expire in '$expires'"
fi

echo "Running: "
cat <<EOF
gpg --quick-generate-key "$name" rsa4096 sign "$expires"
EOF

gpg --quick-generate-key "$name" rsa4096 sign "$expires"

fingerprints="$(gpg --list-keys --with-colons | grep fpr)"
nf=$(wc -l <<<"$fingerprints")
if [[ $nf -gt 1 ]]; then
    exec >&2
    echo 'More than 1 fingerprint present!'
    gpg --list-keys
    exit 1
elif [[ $nf -eq 0 ]]; then
    exec >&2
    echo 'No key fingerprints!'
    exit 1
fi

gpg --export --armor "$fp"
