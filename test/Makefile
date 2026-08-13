


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


suites:
	$(MAKE) -C $@ clean
	$(MAKE) -C $@ COMPILER=sccz80
	$(MAKE) -C $@ clean
	$(MAKE) -C $@ COMPILER=80cc

feature:
	$(MAKE) -C $@ all

all: src-all

src-all:
	$(MAKE) -C ../src/common test
	$(MAKE) -C ../src/ucpp test
	$(MAKE) -C ../src/z80nm test
	$(MAKE) -C ../src/z80asm test
	$(MAKE) -C ../src/zobjcopy test
	#$(MAKE) -C ../src/80cc test
