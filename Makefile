include /usr/share/dpkg/default.mk

PACKAGE=frr

SRCDIR=frr
BUILDDIR=build-$(PACKAGE)-$(DEB_VERSION_UPSTREAM)

GITVERSION:=$(shell git rev-parse HEAD)

MAIN_DEB=$(PACKAGE)_$(DEB_VERSION)_$(DEB_BUILD_ARCH).deb
OTHER_DEBS=\
  frr-doc_$(DEB_VERSION)_all.deb \
  frr-pythontools_$(DEB_VERSION)_all.deb \
  frr-snmp_$(DEB_VERSION)_$(DEB_BUILD_ARCH).deb \

DBG_DEBS=\
  frr-dbgsym_$(DEB_VERSION)_$(DEB_BUILD_ARCH).deb \
  frr-snmp-dbgsym_$(DEB_VERSION)_$(DEB_BUILD_ARCH).deb \

DEBS=$(MAIN_DEB) $(OTHER_DEBS) $(DBG_DEBS)

all: $(DEBS)
	@echo $(DEBS)

.PHONY: submodule
submodule:
	test -f "$(SRCDIR)/debian/changelog" || git submodule update --init

$(BUILDDIR): submodule debian/changelog
	rm -rf $(BUILDDIR) $(BUILDDIR).tmp
	cp -a $(SRCDIR) $(BUILDDIR).tmp
	rm $(BUILDDIR).tmp/debian/changelog
	cp -a debian/* $(BUILDDIR).tmp/debian/
	mv $(BUILDDIR).tmp $(BUILDDIR)

.PHONY: deb
deb: $(DEBS)
$(OTHER_DEBS) $(DBG_DEBS): $(MAIN_DEB)
$(MAIN_DEB): $(BUILDDIR)
	cd $(BUILDDIR); dpkg-buildpackage -b -uc -us --build-profiles="pkg.frr.nortrlib"
	lintian $(DEBS)

.PHONY: upload
upload: $(DEBS)
	tar cf - $(DEBS)|ssh -X repoman@repo.proxmox.com -- upload --product pve --dist bullseye

.PHONY: distclean
distclean: clean

.PHONY: clean
clean:
	rm -rf *~ debian/*~ *.deb build-$(PACKAGE)* *.changes *.dsc *.buildinfo

.PHONY: dinstall
dinstall: deb
	dpkg -i $(DEBS)
