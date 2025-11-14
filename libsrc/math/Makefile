include ../Make.config

SUBDIRS = integer/fastmath float/genmath float/math48 float/math32 float/math16 \
	float/mbf32 float/daimath32 float/am9511 float/cpcmath float/mbf64 float/z88math float/zxmath 
CLEANDIRS = $(SUBDIRS:%=%-clean)


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
