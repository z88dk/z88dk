SUBDIRS = cpc cpm dummy gen_rnd msxdos2 nc100 newbrain osca spectrum sprinter trsdos z88 zxvgs 
CLEANDIRS = $(SUBDIRS:%=clean-%)

include ../Make.config

     
.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)
     
subdirs: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
