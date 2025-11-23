include ../Make.config


SUBDIRS = ace c128 cpc cpm enterprise gb lm80c msx mtx nabu nc newbrain osca oz rex s1mp3 sos svi ticalc trs80 tvc x1 z88 zx80 zx81 aquarius

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
