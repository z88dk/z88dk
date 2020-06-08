include


SUBDIRS = basck debugger graphics pv1000 rcmx000
CLEANDIRS = $(SUBDIRS:%=clean-%)
INSTALLDIRS = $(SUBDIRS:%=install-%)

all: subdirs-all


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean

subdirs-clean: $(CLEANDIRS)


install: subdirs-install

subdirs-install: $(INSTALLDIRS)


.PHONY:	subdirs-all $(SUBDIRS) $(CLEANDIRS) $(INSTALLDIRS)



$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean

$(INSTALLDIRS):
	$(MAKE) -C $(@:install-%=%) PREFIX=$(PREFIX) install
