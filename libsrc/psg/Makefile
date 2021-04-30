include ../Make.config


SUBDIRS = ay sn76489 saa1099

CLEANDIRS = $(SUBDIRS:%=clean-%)

     
.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS) clean
     
subdirs: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
