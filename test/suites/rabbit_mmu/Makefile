include ../make.config

# Rabbit logical-to-physical mapping under z88dk-ticks: SEGSIZE/DATASEG/
# STACKSEG segments, the XPC window, ldp, lcall/ljp/lret.
# mmu.asm leaves its results in root memory at 0x100.

CPUS = r2ka r3k r4k

# Result bytes at 0x100..0x10d, little endian words / bytes
EXPECTED = ef be fe ca aa 55 83 11 44 00 00 00 57 13

all: $(addprefix run_,$(CPUS)) $(addprefix run4k_,r4k r6k) $(addprefix runcrt_,$(CPUS)) banktests fartests far24tests

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

# R4K and later: 12 bit LXPC, llcall/llret/lljp, ldf through the window.
# mmu4k.asm leaves its results at 0x100.
EXPECTED4K = bc 0a 5a 00 ef 0d 77 00 ef 0d 23 01 57 04 77 07

mmu4k.bin: mmu4k.asm
	z88dk-z80asm -mr4k -b mmu4k.asm

run4k_%: mmu4k.bin
	@z88dk-ticks -m$* -end 7f -output mmu4k_$*.out mmu4k.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N16 mmu4k_$*.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(EXPECTED4K)" ]; then \
		echo "$(GREEN)rabbit_mmu 4k $* passed$(RESET)"; \
	else \
		echo "$(RED)rabbit_mmu 4k $* failed: got '$$got'$(RESET)"; exit 1; \
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

# Banked calls and data in three code banks (XPC = bank * 2). The banks are
# loaded after the root image by ticks -banks.
BANK_COMPILERS = sccz80 80cc
BANK_EXPECTED = 42 200 100023 6 4321 1020304

define bank_test
BANK_TESTS += runbank_$(1)_$(2)
runbank_$(1)_$(2): banked_main.c banked_b1.c banked_b2.c banked_b3.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=3 banked_main.c banked_b1.c banked_b2.c banked_b3.c -o bank_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) -banks bank_$(1)_$(2).bin | head -1); \
	if [ "$$$$got" = "$$(BANK_EXPECTED)" ]; then \
		echo "$$(GREEN)rabbit_mmu banked $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu banked $(1) $(2) failed: got '$$$$got'$$(RESET)"; exit 1; \
	fi
endef

$(foreach cpu,$(CPUS),$(foreach comp,$(BANK_COMPILERS),$(eval $(call bank_test,$(cpu),$(comp)))))

banktests: $(BANK_TESTS)

# Far pointers: 24-bit physical addresses through the XPC window. The window
# is also the top of the near address space, so the stack stays below it.
FAR_EXPECTED = 16 17 18 19 | 1234 | 11223344 | 99 3

define far_test
FAR_TESTS += runfar_$(1)_$(2)
runfar_$(1)_$(2): far_main.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=0 far_main.c -o far_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) far_$(1)_$(2).bin | head -1); \
	if [ "$$$$got" = "$$(FAR_EXPECTED)" ]; then \
		echo "$$(GREEN)rabbit_mmu far $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu far $(1) $(2) failed: got '$$$$got'$$(RESET)"; exit 1; \
	fi
endef

$(foreach cpu,$(CPUS),$(foreach comp,$(BANK_COMPILERS),$(eval $(call far_test,$(cpu),$(comp)))))

fartests: $(FAR_TESTS)

# R4K and later: the 12 bit LXPC reaches the whole 16MB space
FAR24_EXPECTED = 11112222 33334444 50 53
CRT_CLIB_r6k = rabbit6k

define far24_test
FAR24_TESTS += runfar24_$(1)_$(2)
runfar24_$(1)_$(2): far24_main.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=0 far24_main.c -o far24_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) far24_$(1)_$(2).bin | head -1); \
	if [ "$$$$got" = "$$(FAR24_EXPECTED)" ]; then \
		echo "$$(GREEN)rabbit_mmu far24 $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu far24 $(1) $(2) failed: got '$$$$got'$$(RESET)"; exit 1; \
	fi
endef

$(foreach cpu,r4k r6k,$(foreach comp,$(BANK_COMPILERS),$(eval $(call far24_test,$(cpu),$(comp)))))

far24tests: $(FAR24_TESTS)

clean:
	rm -f mmu.bin mmu4k.bin mmu_*.out mmu4k_*.out crt_*.bin bank_*.bin bank_*_BANK_*.bin far_*.bin far24_*.bin *.lis *.o *~ zcc_opt.def

.PHONY: all banktests fartests far24tests clean
