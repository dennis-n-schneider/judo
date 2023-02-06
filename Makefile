.SILENT: install

install:
	cp judo /usr/local/bin/judo
	chmod 605 /usr/local/bin/judo
	mkdir /usr/local/share/judo
	chmod 755 /usr/local/share/judo
	cp Dockerfile /usr/local/share/judo/Dockerfile
	chmod 604 /usr/local/share/judo/Dockerfile

uninstall:
	rm -r /usr/local/bin/judo
	rm -r /usr/local/share/judo
