SUBDIRS = genmath z88math zxmath math48 cpcmath fastmath mbf32 mbf64 math16 math32 am9511 daimath32
CLEANDIRS = $(SUBDIRS:%=clean-%)

include ../Make.config
     
.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)
     
subdirs: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
