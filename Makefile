.SECONDEXPANSION: 
.PHONY: install uninstall
.SILENT: install

BINARY=judo
SRC_ROOT=src
ASSETS_ROOT=assets

JUDO_BIN=/usr/local/bin/judo
JUDO_DATA_DIR=/usr/local/share/judo

install: $(JUDO_BIN)

$(JUDO_BIN): $(JUDO_DATA_DIR) \
			$(JUDO_DATA_DIR)/plugins \
			$(subst $(ASSETS_ROOT),$(JUDO_DATA_DIR)/assets,$(wildcard $(ASSETS_ROOT)/*)) \
			$(subst $(SRC_ROOT),$(JUDO_DATA_DIR)/src,$(wildcard $(SRC_ROOT)/*.sh))
	cp -p $(BINARY) $@

$(JUDO_DATA_DIR)/Dockerfile: $(SRC_ROOT)/Dockerfile
	cp -p $< $@

$(subst $(ASSETS_ROOT),$(JUDO_DATA_DIR)/assets,$(wildcard $(ASSETS_ROOT)/*)): $$(subst $$(JUDO_DATA_DIR)/assets, $$(ASSETS_ROOT), $$@)
	mkdir -p $(@D) && chmod 777 $(@D)
	cp -p $< $@

$(subst $(SRC_ROOT),$(JUDO_DATA_DIR)/src,$(wildcard $(SRC_ROOT)/*.sh)): $$(subst $$(JUDO_DATA_DIR)/src, $$(SRC_ROOT), $$@)
	mkdir -p $(@D) && chmod 777 $(@D)
	cp -p $< $@

$(JUDO_DATA_DIR):
	mkdir -p $@ && chmod 777 $@

$(JUDO_DATA_DIR)/plugins:
	touch $@ && chmod 766 $@

uninstall:
	rm $(JUDO_BIN)
	rm -r $(JUDO_DATA_DIR)

