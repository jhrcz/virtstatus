SPECVERSION=$(shell awk -F: '/^Version:/{print $$2}' < virtstatus.spec | awk '{print $$1}' )

test-destdir: step-test-destdir
step-test-destdir:
	#test -d "$(DESTDIR)"
	test -n "$(DESTDIR)"
	touch step-test-destdir

install-cron: step-install-cron
step-install-cron: test-destdir virtstatus.cron
	install -m 644 -D virtstatus.cron $(DESTDIR)/etc/cron.d/virtstatus
	touch step-install-cron

install-conf: step-install-conf
#step-install-conf: test-destdir virtstatus.conf
step-install-conf: test-destdir
	#install -m 644 -D virtstatus.conf $(DESTDIR)/etc/virtstatus/virtstatus.conf
	install -m 644 -D descriptions $(DESTDIR)/etc/virtstatus/descriptions
	install -m 644 -D apache2.conf.inc $(DESTDIR)/etc/virtstatus/apache2.conf.inc
	touch step-install-conf

install-log: step-install-log
step-install-log: test-destdir
	touch step-install-log
    
install-bin: step-install-bin
#step-install-bin: test-destdir virtstatus.sh
step-install-bin: test-destdir
	install -D virtstatus.sh $(DESTDIR)/usr/sbin/virtstatus.sh
	install -D virtstatus-html $(DESTDIR)/usr/bin/virtstatus-html
	touch step-install-bin

install: install-bin install-conf install-cron install-log

clean:
	rm step-* || true
	rm virtstatus-*.tar.gz || true
	rm -rf DESTDIR/

dist:
	git archive --format=tar --prefix="virtstatus-$(SPECVERSION)/" -o virtstatus-$(SPECVERSION).tar HEAD
	rm virtstatus-$(SPECVERSION).tar.gz || true
	gzip virtstatus-$(SPECVERSION).tar

rpm: dist
	cp virtstatus-$(SPECVERSION).tar.gz ~/rpmbuild/SOURCES/
	rpmbuild -bb --clean virtstatus.spec

deb:
	fakeroot dpkg-buildpackage -us -uc

