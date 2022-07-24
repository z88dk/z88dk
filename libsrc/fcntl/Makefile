SUBDIRS = dummy gen_rnd 
CLEANDIRS = $(SUBDIRS:%=%-clean)

include ../Make.config


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS)
	$(RM) */*.o
	$(RM) */zcc_opt.def
	$(RM) */*/zcc_opt.def

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
