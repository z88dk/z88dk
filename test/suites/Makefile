


SUBDIRS = string ctype stdio stdlib target_io math md5 regex sccz80 zx far
# benchmark suites (also self-checking via host-verified assertEqual)
SUBDIRS += charbench crcbench intbench ptrbench sieve rle \
           sortbench queenbench searchbench switchbench \
           structbench vecbench recordbench maskbench \
           strbench listbench interpbench matrixbench \
           hashbench fixedbench histbench lexbench \
           widthbench predbench
# bitfieldbench is NOT in SUBDIRS yet: it still fails on the non-z80 targets
# (r2ka r4k 8080 8085 gbz80 kc160) — see its header. Add it here once that is
# fixed; `make -C bitfieldbench COMPILER=80cc test.bin` runs the z80 case.

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
