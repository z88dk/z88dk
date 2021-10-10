include ../Make.config


SUBDIRS = c128 z88 x1 msx svi nc100 rex zx gb s1mp3 cpc sos ace pps tvc trs80 ticalc mtx oz enterprise cpm osca zx81 zxn zx-common ts2068 newbrain lm80c zx80

CLEANDIRS = $(addprefix clean-,$(SUBDIRS))

     
.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)
     
subdirs: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o 
	$(RM) */*/*.o 
	$(RM) */*/*/*.o 

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
