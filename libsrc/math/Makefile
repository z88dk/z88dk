include ../Make.config

SUBDIRS = fastmath genmath math48 math32 math16 mbf32 daimath32 am9511 cpcmath mbf64 z88math zxmath 
CLEANDIRS = $(SUBDIRS:%=%-clean)


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
