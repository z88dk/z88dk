include ../../../Make.config


SUBDIRS = microdrive plus3 zxbasdrv

CLEANDIRS = $(SUBDIRS:%=%-clean)


.PHONY: subdirs $(SUBDIRS) $(CLEANDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean: subdirs-clean
	$(RM) zcc_opt.def *.err *.o

subdirs-clean: $(CLEANDIRS)

$(CLEANDIRS): 
	$(MAKE) -C $(@:%-clean=%) clean
	$(RM) */*.o
	$(RM) -r obj
