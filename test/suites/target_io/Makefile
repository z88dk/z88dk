include ../make.config

# target_io — serial (printf/scanf) + disk (creat/write/lseek/read/close)
# under z88dk-ticks for multiple targets.
#
# Layout:
#   io_tests.c              shared tests
#   io_port.h               portable fcntl surface (tio_*)
#   fcntl_native.c          backend: native open/creat (CP/M, …)
#   fcntl_host.c            backend: ticks SYSCALL host files
#   ticks_host_fcntl.asm    SYSCALL wrappers for fcntl_host
#
# Adding a target: append a recipe below (compile line + runtest_* style
# ticks invocation). Prefer fcntl_native when the target's fcntl is
# emulated by ticks; use fcntl_host when only SYSCALL host files work.

SCANF_INPUT = 7 99

COMMON_NATIVE = io_tests.c fcntl_native.c $(SOURCES)
COMMON_HOST   = io_tests.c fcntl_host.c ticks_host_fcntl.asm $(SOURCES)

# -D string helpers for TIO_LABEL (sccz80/80cc)
LABEL = -DTIO_LABEL="\"\\\"$(1)\\\"\""

all: \
	test_cpm_z80.com \
	test_cpm_8085.com \
	test_cpm_new_z80.com \
	test_rc2014_z80_CODE.bin \
	test_rc2014_8085_CODE.bin \
	test_rc2014_cpm.com

# ---------------------------------------------------------------------------
# CP/M classic — native fcntl via BDOS; default subtype only (Z80 + 8085)
# ---------------------------------------------------------------------------

test_cpm_z80.com: $(COMMON_NATIVE)
	zcc +cpm -vn $(CFLAGS) $(call LABEL,CPM) $^ -o $@ -m -create-app
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting cpm/z80 target_io $(RESET)"
	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) $@ \
		|| { echo "$(RED)" `date +%H:%M:%S` " cpm/z80 target_io failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " cpm/z80 target_io completed $(RESET)"

test_cpm_8085.com: $(COMMON_NATIVE)
	zcc +cpm -vn -clib=8085 $(CFLAGS) $(call LABEL,CPM) $^ -o $@ -m -create-app
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting cpm/8085 target_io $(RESET)"
	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) -m8085 $@ \
		|| { echo "$(RED)" `date +%H:%M:%S` " cpm/8085 target_io failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " cpm/8085 target_io completed $(RESET)"

# ---------------------------------------------------------------------------
# CP/M newlib — BDOS FCB + character devices (+cpm -clib=new, Z80 only)
# ---------------------------------------------------------------------------

test_cpm_new_z80.com: $(COMMON_NATIVE)
	@# -startup=4 = DCIO console (BDOS 6); startup 0 uses BDOS 10 which ticks lacks
	@# -DTIO_CPM_DEVICES: CRT has stdrdr/stdpun/stdlst + cpm_device_file
	zcc +cpm -clib=new -startup=4 -vn $(CFLAGS) -DTIO_CPM_DEVICES $(call LABEL,CPM-NEW) \
		$^ -o $(@:.com=) -m -create-app
	@# -create-app may emit APP.COM; normalise for ticks
	@if [ -f APP.COM ]; then mv -f APP.COM $@; elif [ -f $(@:.com=_CODE.bin) ]; then cp $(@:.com=_CODE.bin) $@; fi
	@test -f $@ || { echo "missing $@ after link"; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting cpm/newlib z80 target_io $(RESET)"
	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) $@ \
		|| { echo "$(RED)" `date +%H:%M:%S` " cpm/newlib z80 target_io failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " cpm/newlib z80 target_io completed $(RESET)"

# ---------------------------------------------------------------------------
# RC2014 basic — host SYSCALL fcntl; CODE.bin @ 0x9000; name has "rc2014"
# ---------------------------------------------------------------------------

test_rc2014_z80_CODE.bin: $(COMMON_HOST)
	zcc +rc2014 -vn $(CFLAGS) -DTIO_USE_HOST_FCNTL $(call LABEL,RC2014) \
		$^ -o $(@:_CODE.bin=.bin) -clib=new -subtype=basic -m
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting rc2014/z80 target_io $(RESET)"
	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) -pc 0x9000 $@ \
		|| { echo "$(RED)" `date +%H:%M:%S` " rc2014/z80 target_io failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " rc2014/z80 target_io completed $(RESET)"

test_rc2014_8085_CODE.bin: $(COMMON_HOST)
	zcc +rc2014 -vn $(CFLAGS) -DTIO_USE_HOST_FCNTL $(call LABEL,RC2014) \
		$^ -o $(@:_CODE.bin=.bin) -subtype=basic85 -m
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting rc2014/8085 target_io $(RESET)"
	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) -m8085 -pc 0x9000 $@ \
		|| { echo "$(RED)" `date +%H:%M:%S` " rc2014/8085 target_io failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " rc2014/8085 target_io completed $(RESET)"

# ---------------------------------------------------------------------------
# RC2014 CP/M subtype — native FCB fcntl via BDOS (newlib bridge)
# Output is CODE.bin @ 0x100; copy to .com for ticks CP/M mode.
# ---------------------------------------------------------------------------

test_rc2014_cpm.com: $(COMMON_NATIVE)
	@# -DTIO_CPM_DEVICES: subtype=cpm CRT instantiates stdrdr/stdpun/stdlst
	zcc +rc2014 -subtype=cpm -clib=new -vn $(CFLAGS) -DTIO_CPM_DEVICES $(call LABEL,RC2014-CPM) \
		$^ -o $(@:.com=) -m
	cp $(@:.com=_CODE.bin) $@
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting rc2014/cpm target_io $(RESET)"
	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) $@ \
		|| { echo "$(RED)" `date +%H:%M:%S` " rc2014/cpm target_io failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " rc2014/cpm target_io completed $(RESET)"

# ---------------------------------------------------------------------------
# Example: +test host fcntl (commented — enable when wanted)
# test_plus_test_z80.bin: $(COMMON_HOST)
#	zcc +test -vn $(CFLAGS) -DTIO_USE_HOST_FCNTL $(call LABEL,TEST) \
#		$^ -o $@ -m -lndos
#	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) $@ || exit 1
# ---------------------------------------------------------------------------

clean:
	rm -f *.com *.bin *.map *.o *.def zcc_opt.def *~ \
		suite.dat a.dat b.dat fopen.dat \
		test_cpm_* test_rc2014_* TEST_CPM_* TEST.DAT test.dat APP.COM app
