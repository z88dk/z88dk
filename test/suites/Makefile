


SUBDIRS = string ctype stdio stdlib target_io math imath md5 regex sccz80 zx far zcc-multi
# benchmark suites (also self-checking via host-verified assertEqual)
BENCH = charbench crcbench intbench ptrbench sieve rle \
           sortbench queenbench searchbench switchbench \
           structbench vecbench recordbench maskbench \
           strbench listbench interpbench matrixbench \
           hashbench fixedbench histbench lexbench \
           bitfieldbench widthbench predbench \
           shiftbench localbench divbench callbench

ifeq ($(COMPILER),80cc)
SUBDIRS += long_ir debuginfo
endif


all: subdirs-all

bench: bench-all


subdirs-all: $(SUBDIRS)

bench-all: $(BENCH)


clean: subdirs-clean bench-clean

subdirs-clean:
	@for s in $(SUBDIRS); \
	do \
		$(MAKE) -C $$s clean ; \
	done

bench-clean:
	@for s in $(BENCH); \
	do \
		$(MAKE) -C $$s clean ; \
	done


.PHONY:	subdirs-all $(SUBDIRS) bench-all $(BENCH)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(BENCH):
	$(MAKE) -C $@ all
