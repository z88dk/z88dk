include ../Make.config

ALLSUBDIRS = common narrow wide portable x11 gencon

SUBDIRS = common x11
# Directories that need a target passed down

FLAVOUR ?= narrow


SUBDIRS += $(FLAVOUR)

CLEANDIRS = $(ALLSUBDIRS:%=clean-%) $(TARGETDIRS:%=clean-%)

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
	$(MAKE) -C $(@:clean-%=%) clean
