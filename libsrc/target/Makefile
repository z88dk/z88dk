include ../Make.config


SUBDIRS = ace c128 cpc cpm enterprise gb lm80c msx mtx nabu nc100 newbrain osca oz pps rex s1mp3 sos svi ticalc trs80 ts2068 tvc x1 z88 zx-common zx zx80 zx81 zxn aquarius

CLEANDIRS = $(addsuffix -clean,$(SUBDIRS))


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o 
	$(RM) */*/*.o 
	$(RM) */*/*/*.o 
	$(RM) */*/*/*/*.o 

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
