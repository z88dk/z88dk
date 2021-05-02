include ../Make.config


SUBDIRS = fzx font_4x8 font_8x8 font_8x10
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

clean-kludge:
