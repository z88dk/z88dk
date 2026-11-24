


SUBDIRS = suites feature

all: subdirs-all


subdirs-all: $(SUBDIRS)


clean: subdirs-clean

subdirs-clean:
	@for s in $(SUBDIRS); \
	do \
		$(MAKE) -C $$s clean ; \
	done


.PHONY:	subdirs-all $(SUBDIRS)

llvmz80:
	$(MAKE) -C llvmz80 test

.PHONY: llvmz80


# The lines are one recipe, so they stay ordered under -j: every pass writes
# the same test.bin names into the same suite directories, so the passes cannot
# overlap. Concurrency within a pass is fine, and each sub-make picks it up from
# the jobserver. Three passes: sccz80, 80cc with the default (sp) frame, and
# 80cc with the IX frame pointer (FP=1).
suites:
	$(MAKE) -C $@ clean
	$(MAKE) -C $@ COMPILER=sccz80
	$(MAKE) -C $@ clean
	$(MAKE) -C $@ COMPILER=80cc
	$(MAKE) -C $@ clean
	$(MAKE) -C $@ COMPILER=80cc FP=1

feature:
	$(MAKE) -C $@ all

all: src-all

.PHONY: src-all

# Kept as one recipe deliberately: z80nm, z80asm and zobjcopy each compile
# ../common/*.o to the same eight paths with different -I flags, so splitting
# these into separate targets would race under -j.
src-all:
	$(MAKE) -C ../src/common test
	$(MAKE) -C ../src/ucpp test
	$(MAKE) -C ../src/z80nm test
	$(MAKE) -C ../src/z80asm test
	$(MAKE) -C ../src/zobjcopy test
	$(MAKE) -C ../src/zx81bas test
	#$(MAKE) -C ../src/80cc test
