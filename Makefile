.SILENT: install

JUDO_BIN="/usr/local/bin/judo"
JUDO_DATA_DIR="/usr/local/share/judo"

install:
	cp src/judo $(JUDO_BIN)
	mkdir $(JUDO_DATA_DIR)
	cp src/Dockerfile src/plugin-install.sh src/setup-config.sh $(JUDO_DATA_DIR)
	chmod 755 $(JUDO_BIN)
	chmod 777 $(JUDO_DATA_DIR)
	chmod 744 $(JUDO_DATA_DIR)/Dockerfile
	chmod 755 $(JUDO_DATA_DIR)/plugin-install.sh $(JUDO_DATA_DIR)/setup-config.sh

uninstall:
	rm $(JUDO_BIN)
	rm -r $(JUDO_DATA_DIR)
