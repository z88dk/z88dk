include ../Make.config


SUBDIRS = aplib zx7 zx0 zx1 zx2

CLEANDIRS = $(SUBDIRS:%=%-clean)

all: $(SUBDIRS)


subdirs-all: $(SUBDIRS) $(TARGETDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean

subdirs-clean: $(CLEANDIRS)


.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:%-clean=%) clean
