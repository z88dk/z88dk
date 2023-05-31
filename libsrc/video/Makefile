include ../Make.config


SUBDIRS = tms9918 upd7220 krt tek401x regis mc6845 msm6255
# Directories that need a target passed down
CLEANDIRS = $(SUBDIRS:%=%-clean) $(TARGETDIRS:%=%-clean)

all: $(SUBDIRS)


subdirs-all: $(SUBDIRS) $(TARGETDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) */*.o */*/*.o  */*/*/*.o

subdirs-clean: $(CLEANDIRS)


.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:%-clean=%) clean
