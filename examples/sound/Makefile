SUBDIRS = arkos wyz vt2
CLEANDIRS = $(SUBDIRS:%=%-clean)


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
