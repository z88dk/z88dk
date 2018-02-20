include ../Make.config


SUBDIRS = fzx
CLEANDIRS = $(SUBDIRS:%=clean-%)

all: subdirs-all


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN) clean-kludge


clean: subdirs-clean

subdirs-clean: $(CLEANDIRS)


.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)



$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean

clean-kludge:
	$(RM) */*.o
