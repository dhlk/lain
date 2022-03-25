BINARIES := lain-init-wg lain-init-wg-cryptostorm lain-init-wg-mullvad
INTERNAL := wireguard.bash
SYSTEMD := lain-wg@.service lain-wg-ip-check@.service

install:
	install -Dm755 -t "$(DESTDIR)/$(PREFIX)/bin" $(BINARIES)
	install -Dm755 -t "$(DESTDIR)/$(PREFIX)/lib/lain" $(INTERNAL)
	install -Dm644 -t "$(DESTDIR)/$(PREFIX)/lib/systemd/system" $(SYSTEMD)
