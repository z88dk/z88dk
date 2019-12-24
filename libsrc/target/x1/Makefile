include ../../Make.config

TARGET = x1

SUBDIRS = x1 time 
CLEANDIRS = $(SUBDIRS:%=clean-%)

all: subdirs-all 


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) zcc_opt.def *.err *.o

subdirs-clean: $(CLEANDIRS)

.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
	$(RM) */*.o
