SUBDIRS = flos flosmulti
CLEANDIRS = $(SUBDIRS:%=%-clean)

include ../../../Make.config
     
.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)
     
all: $(SUBDIRS)
     
$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
