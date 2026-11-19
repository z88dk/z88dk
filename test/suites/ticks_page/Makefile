include ../make.config

# Z180 MMU, the RC2014 32 kB ROM page (0x38) and 128 kB shadow RAM (0x30),
# and the ZX Next 8 kB MMU.
# POSIX shell (od, sed, printf). Skipped on Windows, same as rabbit_mmu.

UNAME := $(shell uname -s 2>/dev/null)
PAGE_WINDOWS :=
ifeq ($(OS),Windows_NT)
PAGE_WINDOWS := 1
endif
ifneq (,$(findstring CYGWIN,$(UNAME)))
PAGE_WINDOWS := 1
endif
ifneq (,$(findstring MINGW,$(UNAME)))
PAGE_WINDOWS := 1
endif
ifneq (,$(findstring MSYS,$(UNAME)))
PAGE_WINDOWS := 1
endif

# 20 bytes at 0x0100. See z180_mmu.asm.
Z180_EXPECTED = f0 11 22 33 00 a5 00 5a 77 00 66 44 22 3c 21 00 12 ff ff 07

# 2 bytes at 0x0100. See z180_flat.asm. -b standard stays the flat 64 kB.
Z180_FLAT = 11 22

# 6 bytes at 0x8100. See rc2014_page.asm.
RC_EXPECTED = 11 22 22 11 ff a5

# 10 bytes at 0x0200. See zxn_page.asm.
ZXN_EXPECTED = ff 11 11 22 a5 5a 10 42 11 99

# 2 bytes at 0x0100. See zxn_flat.asm.
ZXN_FLAT = 11 22

ifdef PAGE_WINDOWS
all:
	@echo "ticks_page: skipped (POSIX-shell recipes; not run on Windows)"
else
all: z180_auto z180_explicit z180_flat rc_z80 rc_8085 zxn_auto zxn_explicit zxn_flat
endif

z180_mmu.bin: z180_mmu.asm
	z88dk-z80asm -mz180 -b z180_mmu.asm

z180_flat.bin: z180_flat.asm
	z88dk-z80asm -mz180 -b z180_flat.asm

rc2014_page.bin: rc2014_page.asm
	z88dk-z80asm -mz80 -b rc2014_page.asm

zxn_page.bin: zxn_page.asm
	z88dk-z80asm -mz80n -b zxn_page.asm

zxn_flat.bin: zxn_flat.asm
	z88dk-z80asm -mz80n -b zxn_flat.asm

# Page 0x10, two bytes. -banks names this from the program path.
zxn_page_BANK_10.bin:
	printf '\245\132' > zxn_page_BANK_10.bin

z180_auto: z180_mmu.bin
	@z88dk-ticks -mz180 -end 7e -output z180_auto.out z180_mmu.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N20 z180_auto.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(Z180_EXPECTED)" ]; then \
		echo "$(GREEN)ticks_page z180 -mz180 passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page z180 -mz180 failed: got '$$got'$(RESET)"; exit 1; \
	fi

z180_explicit: z180_mmu.bin
	@z88dk-ticks -mz180 -b z180 -end 7e -output z180_explicit.out z180_mmu.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N20 z180_explicit.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(Z180_EXPECTED)" ]; then \
		echo "$(GREEN)ticks_page z180 -b z180 passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page z180 -b z180 failed: got '$$got'$(RESET)"; exit 1; \
	fi

z180_flat: z180_flat.bin
	@z88dk-ticks -mz180 -b standard -end 7e -output z180_flat.out z180_flat.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N2 z180_flat.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(Z180_FLAT)" ]; then \
		echo "$(GREEN)ticks_page z180 -b standard passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page z180 -b standard failed: got '$$got'$(RESET)"; exit 1; \
	fi

rc_z80: rc2014_page.bin
	@z88dk-ticks -mz80 -b rc2014 -end 807e -output rc_z80.out rc2014_page.bin > /dev/null
	@got=$$(od -An -tx1 -j33024 -N6 rc_z80.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(RC_EXPECTED)" ]; then \
		echo "$(GREEN)ticks_page rc2014 z80 passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page rc2014 z80 failed: got '$$got'$(RESET)"; exit 1; \
	fi

rc_8085: rc2014_page.bin
	@z88dk-ticks -m8085 -b rc2014 -end 807e -output rc_8085.out rc2014_page.bin > /dev/null
	@got=$$(od -An -tx1 -j33024 -N6 rc_8085.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(RC_EXPECTED)" ]; then \
		echo "$(GREEN)ticks_page rc2014 8085 passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page rc2014 8085 failed: got '$$got'$(RESET)"; exit 1; \
	fi

zxn_auto: zxn_page.bin zxn_page_BANK_10.bin
	@z88dk-ticks -mz80n -banks -end 7e -output zxn_auto.out zxn_page.bin > /dev/null
	@got=$$(od -An -tx1 -j512 -N10 zxn_auto.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(ZXN_EXPECTED)" ]; then \
		echo "$(GREEN)ticks_page zxn -mz80n passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page zxn -mz80n failed: got '$$got'$(RESET)"; exit 1; \
	fi

zxn_explicit: zxn_page.bin zxn_page_BANK_10.bin
	@z88dk-ticks -b zxn -mz80n -banks -end 7e -output zxn_explicit.out zxn_page.bin > /dev/null
	@got=$$(od -An -tx1 -j512 -N10 zxn_explicit.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(ZXN_EXPECTED)" ]; then \
		echo "$(GREEN)ticks_page zxn -b zxn passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page zxn -b zxn failed: got '$$got'$(RESET)"; exit 1; \
	fi

zxn_flat: zxn_flat.bin
	@z88dk-ticks -mz80n -b standard -end 7e -output zxn_flat.out zxn_flat.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N2 zxn_flat.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(ZXN_FLAT)" ]; then \
		echo "$(GREEN)ticks_page zxn -b standard passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page zxn -b standard failed: got '$$got'$(RESET)"; exit 1; \
	fi

clean:
	rm -f *.bin *.o *.lis *.out *.sym *.map zcc_opt.def

.PHONY: all clean z180_auto z180_explicit z180_flat rc_z80 rc_8085 zxn_auto zxn_explicit zxn_flat
