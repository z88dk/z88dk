


SUBDIRS = string ctype stdio stdlib math md5 regex sccz80 zx far

ifeq ($(COMPILER),80cc)
SUBDIRS += long_ir
endif


all: subdirs-all


subdirs-all: $(SUBDIRS)


clean: subdirs-clean

subdirs-clean:
	@for s in $(SUBDIRS); \
	do \
		$(MAKE) -C $$s clean ; \
	done


.PHONY:	subdirs-all $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ all
