include ../../Make.config

TARGET = z88

SUBDIRS = z88 net time fcntl rs232
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
