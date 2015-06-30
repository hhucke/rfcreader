#!/usr/bin/make -j
# vim:nowrap:
##
## makefile
##
DESTDIR:=
PACKAGENAME:=rfcreader
PREFIX:=/usr
EXEC_PREFIX:=$(PREFIX)
BINDIR:=$(EXEC_PREFIX)/bin
SBINDIR:=$(EXEC_PREFIX)/sbin
SYSCONFDIR:=/etc
DATADIR:=$(PREFIX)/share
INCLUDEDIR:=$(PREFIX)/include
LIBDIR:=$(PREFIX)/lib
LIBEXECDIR:=$(EXEC_PREFIX)/libexec
LOCALSTATEDIR:=/var
SHAREDSTATEDIR:=$(PREFIX)/com
MANDIR:=$(DATADIR)/man
INFODIR:=$(DATADIR)/info
DIRBASE:=$(PACKAGENAME)
RFCCACHEDIR:=$(LOCALSTATEDIR)/cache/rfcs

include $(PACKAGENAME).ver

export PACKAGENAME DIRBASE
export DESTDIR PREFIX EXEC_PREFIX
export BINDIR SBINDIR SYSCONFDIR DATADIR INCLUDEDIR LIBDIR LIBEXECDIR
export LOCALSTATEDIR SHAREDSTATEDIR RFCCACHEDIR
export MANDIR INFODIR
export VERSION REVISION

install:=install
link:=ln -sfn

rpms:=$(patsubst %.in,%,$(wildcard rpm/*.in))
rpmins:=$(wildcard rpm/*.in)
debs:=$(patsubst %.in,%,$(wildcard debian/*.in))
debins:=$(wildcard debian/*.in)
others:=$(patsubst %.in,%,$(wildcard *.in))
otherins:=$(wildcard *.in)
all:=$(rpms) $(debs) $(others)
allins:=$(rpmins) $(debins) $(otherins)
allfiles:=$(all) configure makefile
allinfiles:=$(allins) configure makefile

.PHONY: all $(PACKAGENAME).ver
all: $(all)

build:
	@echo "Sorry. Nothing to do to build this sofware"

$(all): %: %.in
	./configure $<

rpm/$(PACKAGENAME).spec: rpm/$(PACKAGENAME).spec.in $(PACKAGENAME).ver

.PHONY: install install-$(PACKAGENAME)
install-$(PACKAGENAME):
install:
	install -d -m 1777 -o nobody -g nogroup $(DESTDIR)/$(RFCCACHEDIR); \
	install -D $(PACKAGENAME) $(DESTDIR)/$(BINDIR)/$(PACKAGENAME); \
	install -D -m 0644 $(PACKAGENAME).1 $(DESTDIR)/$(MANDIR)/man1/$(PACKAGENAME).1; \
	install -D -m 0644 $(PACKAGENAME).de.1 $(DESTDIR)/$(MANDIR)/de/man1/$(PACKAGENAME).1; \

.PHONY: clean
clean:
	rm -fv $(filter-out makefile,$(all)) $(PACKAGENAME)-$(VERSION)-$(REVISION).tgz

rpm: $(PACKAGENAME)-$(VERSION)-$(REVISION).tgz rpm/$(PACKAGENAME).spec
	rpmbuild --clean --target=noarch-aeon-linux -ta $(PACKAGENAME)-$(VERSION)-$(REVISION).tgz
	touch rpm

debian: $(allfiles)
	debuild -us -uc -tc -I'.git*' -v$(VERSION).$(REVISION)
	touch debian

.PHONY: tarfile
tarfile: $(PACKAGENAME)-$(VERSION)-$(REVISION).tgz

$(PACKAGENAME)-$(VERSION)-$(REVISION).tgz: $(allinfiles) rpm/$(PACKAGENAME).spec
	tar zcCf ../ $(PACKAGENAME)-$(VERSION)-$(REVISION).tgz --exclude=".git*" --exclude="$(PACKAGENAME)-$(VERSION)-$(REVISION).tgz" $(addprefix $(PACKAGENAME)/, $(allinfiles) rpm/$(PACKAGENAME).spec)

