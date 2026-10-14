include ../make.config

# Newlib malloc is Z80 only. +cpm -clib=new -startup=4 gives ticks a .com
# whose console is BDOS 6. The process exit byte is written at 0x80.

CFLAGS += -DMAX_TESTS=100 -DNO_LOG_RUNNING -DNO_LOG_PASSED

SOURCES += main.c malloc.c malloc_fl.c

all: test_new.com

define normalise_cpm_com
	@if [ -f APP.COM ]; then mv -f APP.COM $@; \
	 elif [ -f $(@:.com=_CODE.bin) ]; then cp $(@:.com=_CODE.bin) $@; \
	 elif u=$$(printf '%s\n' '$@' | tr '[:lower:]' '[:upper:]'); [ -f "$$u" ]; then \
		mv -f "$$u" $@.tmp && mv -f $@.tmp $@; \
	 fi
	@test -f $@ || { echo "missing $@ after link"; exit 1; }
endef

test_new.com: $(SOURCES)
	zcc +cpm -clib=new -startup=4 -vn $(CFLAGS) $^ -o $(@:.com=) -m -create-app
	$(call normalise_cpm_com)
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting newlib malloc $(RESET)"
	@$(MACHINE) $@ || { echo "$(RED)" `date +%H:%M:%S` " newlib malloc failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " newlib malloc completed $(RESET)"

clean:
	rm -f *.com *.bin *.map *.o *.def zcc_opt.def *~ test_new* TEST_NEW*
