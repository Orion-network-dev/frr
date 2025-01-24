#!/bin/sh

0> debian/changelog
cat <<EOF >> debian/changelog
frr (8.5.2-0+orion) unstable; urgency=medium

  * Enable necessary FRR daemons for Orion (bgp and pim)

 -- Matthieu Pignolet <m@mpgn.dev>  Fri, 24 Jan 2025 13:47:59 +0400

EOF

cat frr/debian/changelog >> debian/changelog