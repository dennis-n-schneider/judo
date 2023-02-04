.SILENT: install

install:
	cp jupy /usr/local/bin/jupy
	chmod 605 /usr/local/bin/jupy
	mkdir -p /usr/local/share/jupy
	cp Dockerfile /usr/local/share/jupy/Dockerfile
	chmod 604 /usr/local/share/jupy/Dockerfile

uninstall:
	rm -r /usr/local/bin/jupy
	rm -r /usr/local/share/jupy
