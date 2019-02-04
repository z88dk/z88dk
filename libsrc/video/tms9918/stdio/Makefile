include ../../../Make.config


SUBDIRS = ansi generic_console
CLEANDIRS = $(SUBDIRS:%=clean-%)

all: $(SUBDIRS)


subdirs-all: $(SUBDIRS) $(TARGETDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean

subdirs-clean: $(CLEANDIRS)


.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all TARGET=$(TARGET)

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
	$(RM) */*.o
