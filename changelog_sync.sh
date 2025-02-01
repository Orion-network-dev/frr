#!/bin/sh

# Release information variables
VERSION=$(cd frr; git describe --tags --abbrev=0 | sed -e "s/^frr-//")
DATE=$(date -R)

# Removing the current changelog file
0> debian/changelog

# Adding the new patch-ed release
cat <<EOF >> debian/changelog
frr ($VERSION+orion) unstable; urgency=medium

  * Enable necessary FRR daemons for Orion (bgp and pim)

 -- Matthieu Pignolet <m@mpgn.dev>  $DATE

EOF

# Appending the remaining release information
cat frr/debian/changelog >> debian/changelog
