include ../make.config

# Rabbit logical-to-physical mapping under z88dk-ticks: SEGSIZE/DATASEG/
# STACKSEG segments, the XPC window, ldp, lcall/ljp/lret.
# mmu.asm leaves its results in root memory at 0x100.

CPUS = r2ka r3k r4k

# Result bytes at 0x100..0x10d, little endian words / bytes
EXPECTED = ef be fe ca aa 55 83 11 44 00 00 00 57 13

all: $(addprefix run_,$(CPUS)) $(addprefix runcrt_,$(CPUS)) banktests

mmu.bin: mmu.asm
	z88dk-z80asm -mr3k -b mmu.asm

run_%: mmu.bin
	@z88dk-ticks -m$* -end 7e -output mmu_$*.out mmu.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N14 mmu_$*.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(EXPECTED)" ]; then \
		echo "$(GREEN)rabbit_mmu $* passed$(RESET)"; \
	else \
		echo "$(RED)rabbit_mmu $* failed: got '$$got'$(RESET)"; exit 1; \
	fi

# crt_init_rabbit.inc: the crt programs the MMU from CRT_RABBIT_* pragmas
CRT_CLIB_r2ka = rabbit
CRT_CLIB_r3k  = rabbit
CRT_CLIB_r4k  = rabbit4k
CRT_PRAGMAS = -pragma-define:CRT_RABBIT_SEGSIZE=0x84 \
	-pragma-define:CRT_RABBIT_DATASEG=0x10 \
	-pragma-define:CRT_RABBIT_STACKSEG=0x20 \
	-pragma-define:CRT_RABBIT_XPC=0x82

runcrt_%: crt_mmu.c
	@zcc +test -clib=$(CRT_CLIB_$*) $(CRT_PRAGMAS) crt_mmu.c -o crt_$*.bin
	@got=$$(z88dk-ticks -m$* crt_$*.bin | head -1); \
	if [ "$$got" = "xpc=82 segsize=84 dataseg=10 stackseg=20" ]; then \
		echo "$(GREEN)rabbit_mmu crt $* passed$(RESET)"; \
	else \
		echo "$(RED)rabbit_mmu crt $* failed: got '$$got'$(RESET)"; exit 1; \
	fi

# Banked calls: functions in two code banks (XPC = bank * 2). The banks are
# loaded after the root image by ticks -banks. BANK_ASM adds banked_call.asm
# when the startup library is older than the source.
BANK_COMPILERS = sccz80 80cc
BANK_EXPECTED = 42 200 100023 6
BANK_ASM =

define bank_test
BANK_TESTS += runbank_$(1)_$(2)
runbank_$(1)_$(2): banked_main.c banked_b1.c banked_b2.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=2 $$(BANK_ASM) banked_main.c banked_b1.c banked_b2.c -o bank_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) -banks bank_$(1)_$(2).bin | head -1); \
	if [ "$$$$got" = "$$(BANK_EXPECTED)" ]; then \
		echo "$$(GREEN)rabbit_mmu banked $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu banked $(1) $(2) failed: got '$$$$got'$$(RESET)"; exit 1; \
	fi
endef

$(foreach cpu,$(CPUS),$(foreach comp,$(BANK_COMPILERS),$(eval $(call bank_test,$(cpu),$(comp)))))

banktests: $(BANK_TESTS)

clean:
	rm -f mmu.bin mmu_*.out crt_*.bin bank_*.bin bank_*_BANK_*.bin *.lis *.o *~ zcc_opt.def

.PHONY: all banktests clean
