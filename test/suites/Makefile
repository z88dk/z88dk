


SUBDIRS = string ctype stdio stdlib math md5 regex sccz80 zx far
# benchmark suites (also self-checking via host-verified assertEqual)
SUBDIRS += charbench crcbench intbench ptrbench sieve rle \
           sortbench queenbench searchbench switchbench \
           structbench vecbench recordbench maskbench \
           strbench listbench interpbench matrixbench \
           hashbench fixedbench histbench lexbench

ifeq ($(COMPILER),80cc)
SUBDIRS += long_ir debuginfo
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
