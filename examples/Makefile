SUBDIRS = console ticalc ace cpm embedded msx osca rex sam sms sos spectrum vz z88 zxvgs pacman rcmx000 g800 gb c128 nabu sound ticalc/multi_page_flash_app
CLEANDIRS = $(SUBDIRS:%=%-clean)


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
