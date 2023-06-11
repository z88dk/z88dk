include ../../../Make.config

SUBDIRS = esxdos

CLEANDIRS = $(SUBDIRS:%=%-clean)


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: subdirs-clean
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
	$(RM) */*.o */*/*.o

subdirs-clean: $(CLEANDIRS)

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
	$(RM) */*.o
