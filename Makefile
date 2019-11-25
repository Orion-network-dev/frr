PACKAGE=frr
VER=7.2
PKGREL=1+pve

SRCDIR=frr
BUILDDIR=${SRCDIR}.tmp

ARCH:=$(shell dpkg-architecture -qDEB_BUILD_ARCH)

GITVERSION:=$(shell git rev-parse HEAD)

DEB=${PACKAGE}_${VER}-${PKGREL}_${ARCH}.deb

all: ${DEB}
	@echo ${DEB}

.PHONY: submodule
submodule:
	test -f "${SRCDIR}/debian/changelog" || git submodule update --init

.PHONY: deb
deb: ${DEB}
${DEB}: | submodule
	rm -f *.deb
	rm -rf $(BUILDDIR)
	cp -rpa ${SRCDIR} ${BUILDDIR}
	rm $(BUILDDIR)/debian/changelog
	cp -R debian/* $(BUILDDIR)/debian/
	cd ${BUILDDIR};  DEB_BUILD_PROFILES=pkg.frr.nortrlib dpkg-buildpackage -rfakeroot -b -uc -us

.PHONY: upload
upload: ${DEB}
	tar cf - ${DEB}|ssh -X repoman@repo.proxmox.com -- upload --product pmg,pve --dist stretch

.PHONY: distclean
distclean: clean

.PHONY: clean
clean:
	rm -rf *~ debian/*~ *.deb ${BUILDDIR} *.changes *.dsc *.buildinfo

.PHONY: dinstall
dinstall: deb
	dpkg -i ${DEB}
