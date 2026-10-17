include ../make.config

# Rabbit logical-to-physical mapping under z88dk-ticks: SEGSIZE/DATASEG/
# STACKSEG segments, the XPC window, ldp, lcall/ljp/lret.
# mmu.asm leaves its results in root memory at 0x100.

CPUS = r2ka r3k r4k

# Result bytes at 0x100..0x10d, little endian words / bytes
EXPECTED = ef be fe ca aa 55 83 11 44 00 00 00 57 13

all: $(addprefix run_,$(CPUS))

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

clean:
	rm -f mmu.bin mmu_*.out *.lis *.o *~

.PHONY: all clean
