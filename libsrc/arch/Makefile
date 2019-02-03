include ../Make.config


SUBDIRS = z80 c128 z88 x1 msx 
# Directories that need a target passed down
TARGETDIRS = tms9918
CLEANDIRS = $(SUBDIRS:%=clean-%) $(TARGETDIRS:%=clean-%)

all: 


subdirs-all: $(SUBDIRS) $(TARGETDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean

subdirs-clean: $(CLEANDIRS)


.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)


tms9918:
	$(MAKE) -C tms9918 TARGET=$(TARGET) all

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
	$(RM) */*.o
