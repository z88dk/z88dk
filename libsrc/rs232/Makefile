include ../Make.config


SUBDIRS = osca  z88 cpc spectrum svi
CLEANDIRS = $(SUBDIRS:%=clean-%)

all: subdirs-all


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean

subdirs-clean: $(CLEANDIRS)


.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)



$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
