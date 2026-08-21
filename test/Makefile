


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


# The four lines are one recipe, so they stay ordered under -j: both compilers
# write the same test.bin names into the same suite directories, so the passes
# cannot overlap. Concurrency within a pass is fine, and each sub-make picks it
# up from the jobserver.
suites:
	$(MAKE) -C $@ clean
	$(MAKE) -C $@ COMPILER=sccz80
	$(MAKE) -C $@ clean
	$(MAKE) -C $@ COMPILER=80cc

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
	#$(MAKE) -C ../src/80cc test
