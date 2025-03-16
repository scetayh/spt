.PHONY: install uninstall

install:
	mkdir -p /usr/local/bin
	cp src/spt-gen.sh /usr/local/bin/spt-gen
	chmod +x /usr/local/bin/spt-gen
	cp src/spt-clean.sh /usr/local/bin/spt-clean
	chmod +x /usr/local/bin/spt-clean
	mkdir -p /usr/local/share/spt
	cp data/work.conf /usr/local/share/spt/work.conf
	cp data/art.conf /usr/local/share/spt/art.conf

uninstall: 
	rm -f /usr/local/bin/spt-gen
	rm -f /usr/local/bin/spt-clean
	rm -rf /usr/local/share/spt