include ../Make.config


SUBDIRS = c128 z88 x1 msx svi nc100 rex zx gb s1mp3
# Directories that need a target passed down
CLEANDIRS = $(SUBDIRS:%=clean-%) $(TARGETDIRS:%=clean-%)

all: $(SUBDIRS)


subdirs-all: $(SUBDIRS) $(TARGETDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) */*.o */*/*.o 

subdirs-clean: $(CLEANDIRS)


.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
