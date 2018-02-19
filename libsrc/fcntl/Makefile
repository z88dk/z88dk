SUBDIRS = cpc cpm dummy gen_rnd nc100 newbrain osca spectrum sprinter z88 zxvgs
CLEANDIRS = $(SUBDIRS:%=clean-%)

include ../Make.config

     
.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)
     
subdirs: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
