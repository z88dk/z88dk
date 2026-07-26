include ../make.config

# RC2014 I/O suite: serial (printf/scanf) + host disk (creat/write/lseek/read/close)
# under z88dk-ticks.  Filename must contain "rc2014" so ticks installs RST hooks.
#
# Verified with COMPILER=sccz80 and COMPILER=80cc for both basic (Z80) and
# basic85 (8085). Parent test/Makefile runs suites under both compilers.

# Pipe provides scanf serial input (RST 10)
SCANF_INPUT = 7 99

all: test_rc2014_io_CODE.bin test_rc2014_io85_CODE.bin

test_rc2014_io_CODE.bin: rc2014_io.c ticks_host_fcntl.asm $(SOURCES)
	$(call compile_rc2014,,)
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting rc2014/z80 I/O test $(RESET)"
	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) -pc 0x9000 $@ \
		|| { echo "$(RED)" `date +%H:%M:%S` " rc2014/z80 I/O test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " rc2014/z80 I/O test completed $(RESET)"

test_rc2014_io85_CODE.bin: rc2014_io.c ticks_host_fcntl.asm $(SOURCES)
	$(call compile_rc2014_8085,,)
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting rc2014/8085 I/O test $(RESET)"
	@printf '%s\n' '$(SCANF_INPUT)' | $(MACHINE) -m8085 -pc 0x9000 $@ \
		|| { echo "$(RED)" `date +%H:%M:%S` " rc2014/8085 I/O test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " rc2014/8085 I/O test completed $(RESET)"

clean:
	rm -f *.bin *.map *.o *.def zcc_opt.def *~ \
		rc2014_suite.dat rc2014_a.dat rc2014_b.dat \
		test_rc2014_io* test_rc2014_io85*
