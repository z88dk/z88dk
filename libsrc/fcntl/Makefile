SUBDIRS = dummy gen_rnd msxdos2 newbrain osca spectrum 
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
