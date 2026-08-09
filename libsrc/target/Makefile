include ../Make.config


SUBDIRS = ace c128 cpc cpm enterprise gb msx nabu nc newbrain osca oz svi ticalc trs80 x1 zx80 zx81 aquarius

CLEANDIRS = $(addsuffix -clean,$(SUBDIRS))


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o 
	$(RM) -fr */obj
	$(RM) */*/*.o 
	$(RM) */*/*/*.o 
	$(RM) */*/*/*/*.o 

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
