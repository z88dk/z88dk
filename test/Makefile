


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

$(SUBDIRS):
	$(MAKE) -C $@ all

all: src-all

src-all:
	$(MAKE) -C ../src/common test
	$(MAKE) -C ../src/z80asm test
	$(MAKE) -C ../src/zobjcopy test
