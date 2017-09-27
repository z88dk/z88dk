SUBDIRS = genmath z88math zxmath math48 cpcmath fastmath
CLEANDIRS = $(SUBDIRS:%=clean-%)

     
.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)
     
subdirs: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
