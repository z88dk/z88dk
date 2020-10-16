include ../Make.config


SUBDIRS = ay sn76489

CLEANDIRS = $(SUBDIRS:%=clean-%)

     
.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS) clean
     
subdirs: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
