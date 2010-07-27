DESTDIR:=
packagename:=rfcreader
prefix:=/usr
exec_prefix:=/usr
bindir:=/usr/bin
sbindir:=/usr/sbin
sysconfdir:=/etc
datadir:=/usr/share
includedir:=/usr/include
libdir:=/usr/lib
libexecdir:=/usr/libexec
localstatedir:=/var
sharedstatedir:=/usr/com
mandir:=/usr/share/man
infodir:=/usr/local/info:/usr/share/info:/usr/info
version:=1.0
revision:=0
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

.PHONY: all version.info
build:
	@echo "Sorry. Nothing to do to build thism sofware"

$(all): %: %.in
	./configure --sysconfdir=/etc --localstatedir=/var $<

makefile: version.info

rpm/rfcreader.spec: version.info

.PHONY: install
install:
	@if [ -z "$(debianpackage)" ]; then \
		install -d -m 1777 $(DESTDIR)/$(localstatedir)/cache/rfcs; \
		install -D $(packagename) $(DESTDIR)/$(bindir)/$(packagename); \
		install -D -m 0644 $(packagename).1 $(DESTDIR)/$(mandir)/man1/$(packagename).1; \
		install -D -m 0644 $(packagename).de.1 $(DESTDIR)/$(mandir)/de/man1/$(packagename).1; \
	else \
		$(install) categories $(sysconfdir)/$(packagename)/; \
		$(install) $(packagename) $(sbindir)/; \
		$(link) ./$(packagename) $(sbindir)/update-blacklist; \
		$(link) ./$(packagename) $(sbindir)/blacklist-tool; \
	fi

.PHONY: clean
clean:
	rm -fv $(filter-out makefile,$(all)) $(packagename)-$(version)-$(revision).tgz

rpm: $(packagename)-$(version)-$(revision).tgz rpm/rfcreader.spec
	rpmbuild --clean --target=noarch-aeon-linux -ta $(packagename)-$(version)-$(revision).tgz
	touch rpm

debian: $(allfiles)
	dpkg-buildpackage -rsudo -d -b -us -uc -tc -I'.svn*'
	touch debian

.PHONY: tarfile
tarfile: $(packagename)-$(version)-$(revision).tgz

$(packagename)-$(version)-$(revision).tgz: $(allinfiles) rpm/rfcreader.spec
	tar zcCf ../ $(packagename)-$(version)-$(revision).tgz --exclude=".svn*" --exclude="$(packagename)-$(version)-$(revision).tgz" $(addprefix $(packagename)/, $(allinfiles) rpm/rfcreader.spec)
