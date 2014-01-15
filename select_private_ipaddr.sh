#!/bin/bash

function die_error() {
    [[ -n "$*" ]] && echo "ERROR: $*"
    exit 1
}

## Check that vagrant is installed.
VG=$(which vagrant)
[[ -e $VG ]] || die_error "Vagrant is not installed!"

NETWORK="192.168.22"

## We need the landrush plugin to make this trick work.
$VG plugin list | grep -q "landrush" \
    || die_error "The 'landrush' Vagrant plugin is required.  Please install it an try again."

used_host_addr=()
for node in $($VG landrush dependentvms | awk '{ print $2; }') ; do
    last_octet=$(dig @localhost -p 10053 $node +short | awk -F '.' '{ print $NF; }')
    used_host_addr+=($last_octet)
done

echo -n "${NETWORK}."
comm -13 \
<(echo ${used_host_addr[*]} | tr "[:space:]" "\n" | sort -n -) \
<(seq 2 253 | tr "[:space:]" "\n") \
| head -1
