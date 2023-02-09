.SECONDEXPANSION: 
.PHONY: install uninstall
.SILENT: install

BINARY=src/judo
SRC_ROOT=src

JUDO_BIN=/usr/local/bin/judo
JUDO_DATA_DIR=/usr/local/share/judo

install: $(JUDO_BIN)

$(JUDO_BIN): $(JUDO_DATA_DIR) $(JUDO_DATA_DIR)/plugins $(JUDO_DATA_DIR)/Dockerfile $(subst $(SRC_ROOT),$(JUDO_DATA_DIR),$(wildcard $(SRC_ROOT)/*.sh))
	cp -p $(BINARY) $@

$(JUDO_DATA_DIR)/Dockerfile: $(SRC_ROOT)/Dockerfile
	cp -p $< $@

$(subst $(SRC_ROOT),$(JUDO_DATA_DIR),$(wildcard $(SRC_ROOT)/*.sh)): $$(subst $$(JUDO_DATA_DIR), $$(SRC_ROOT), $$@)
	cp -p $< $@

$(JUDO_DATA_DIR):
	mkdir $@ && chmod 777 $@

$(JUDO_DATA_DIR)/plugins:
	touch $@ && chmod 766 $@

uninstall:
	rm $(JUDO_BIN)
	rm -r $(JUDO_DATA_DIR)

