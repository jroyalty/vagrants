#!/bin/bash

function die_error() {
    [[ -n "$*" ]] && echo "ERROR: $*"
    exit 1
}

## Check that vagrant is installed.
VG=$(which vagrant)
[[ -e $VG ]] || die_error "Vagrant is not installed!"

## List of plugins to install.
PLUGINS=(
    vagrant-cachier
)

## Plugins that are already installed.  We'll filter these out in the install
## loop so this script can be run multiple times.
installed_plugins="$($VG plugin list)"

## Install/update plugins.
for p in ${PLUGINS[@]} ; do
    if (echo "$installed_plugins" | grep -q $p) ; then
	echo "Skipping already installed plugin: $p"
    else
	$VG plugin install $p
	[[ $? -eq 0 ]] || die_error "Unable to install plugin $p"
    fi
done

