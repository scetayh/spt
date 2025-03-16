.PHONY: install uninstall

install:
	mkdir -p /usr/local/bin
	cp src/spt.sh /usr/local/bin/spt
	chmod +x /usr/local/bin/spt
	mkdir -p /usr/local/share/spt
	cp data/work.conf /usr/local/share/spt/work.conf
	cp data/art.conf /usr/local/share/spt/art.conf

uninstall: 
	rm -f /usr/local/bin/spt
	rm -rf /usr/local/share/spt