# $Id: Makefile,v 1.6 2012-06-26 06:09:52 stefano Exp $

SUBDIRS = booster sti

all: subdirs-all

subdirs-all:	$(SUBDIRS)


$(SUBDIRS):
	$(MAKE) -C $@

clean:
	@for s in $(SUBDIRS); \
	do \
		$(MAKE) -C $$s clean; \
	done

.PHONY: $(SUBDIRS) subdirs-all

