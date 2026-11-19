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

# 16 bytes at 0x8100. See rc2014_firmware.asm.
RC_FW = a5 a5 00 5a c3 06 f2 11 c3 77 00 00 00 c3 c3 a5

# 3 bytes at 0x0100. See z180_common.asm.
Z180_COMMON = ab ab cd

# 2 bytes at 0x0100. See ez80_ed28.asm.
EZ80_ED28 = 11 55

# 6 bytes at 0x8100. See rc2014_disk85_ram.asm.
DISK85 = c3 11 77 00 12 00

# 10 bytes at 0x0200. See zxn_page.asm.
ZXN_EXPECTED = ff 11 11 22 a5 5a 10 42 11 99

# 2 bytes at 0x0100. See zxn_flat.asm.
ZXN_FLAT = 11 22

ifdef PAGE_WINDOWS
all:
	@echo "ticks_page: skipped (POSIX-shell recipes; not run on Windows)"
else
all: z180_auto z180_explicit z180_flat z180_common rc_z80 rc_8085 rc_romsize \
	rc_fw_z80 rc_fw_8085 disk85 ez80_ed28 zxn_auto zxn_explicit zxn_flat
endif

z180_mmu.bin: z180_mmu.asm
	z88dk-z80asm -mz180 -b z180_mmu.asm

z180_flat.bin: z180_flat.asm
	z88dk-z80asm -mz180 -b z180_flat.asm

rc2014_page.bin: rc2014_page.asm
	z88dk-z80asm -mz80 -b rc2014_page.asm

rc2014_firmware.bin: rc2014_firmware.asm
	z88dk-z80asm -m8085 -b rc2014_firmware.asm

z180_common.bin: z180_common.asm
	z88dk-z80asm -mz180 -b z180_common.asm

ez80_ed28.bin: ez80_ed28.asm
	z88dk-z80asm -mz80 -b ez80_ed28.asm

disk85_rom.bin: disk85_rom.asm
	z88dk-z80asm -m8085 -b disk85_rom.asm

rc2014_disk85_ram.bin: rc2014_disk85_ram.asm
	z88dk-z80asm -m8085 -b rc2014_disk85_ram.asm

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

# -romsize 2000 is hex. The write at 0x1000 is inside that ROM. It must still
# reach the RAM page.
rc_romsize: rc2014_page.bin
	@z88dk-ticks -mz80 -b rc2014 -romsize 2000 -end 807e -output rc_romsize.out rc2014_page.bin > /dev/null
	@got=$$(od -An -tx1 -j33024 -N6 rc_romsize.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(RC_EXPECTED)" ]; then \
		echo "$(GREEN)ticks_page rc2014 -romsize passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page rc2014 -romsize failed: got '$$got'$(RESET)"; exit 1; \
	fi

# Firmware start. The logical results are at 0x8100. The ROM, page 0, and
# page 1 views start at file offsets 0x11000, 0x19000, and 0x29000.
rc_fw_z80: rc2014_firmware.bin
	@z88dk-ticks -mz80 -b rc2014 -end 807e -output rc_fw_z80.out rc2014_firmware.bin > /dev/null
	@$(MAKE) rc_fw_check OUT=rc_fw_z80.out CPU=z80

rc_fw_8085: rc2014_firmware.bin
	@z88dk-ticks -m8085 -b rc2014 -end 807e -output rc_fw_8085.out rc2014_firmware.bin > /dev/null
	@$(MAKE) rc_fw_check OUT=rc_fw_8085.out CPU=8085

rc_fw_check:
	@got=$$(od -An -tx1 -j33024 -N16 $(OUT) | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" != "$(RC_FW)" ]; then \
		echo "$(RED)ticks_page rc2014 firmware $(CPU) failed: got '$$got'$(RESET)"; exit 1; \
	fi
	@check() { \
		got=$$(od -An -tx1 -j "$$1" -N1 $(OUT) | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
		if [ "$$got" != "$$2" ]; then \
			echo "$(RED)ticks_page rc2014 firmware $(CPU) $$3: got '$$got'$(RESET)"; exit 1; \
		fi; \
	}; \
	check $$((0x11000)) c3 "ROM 0"; \
	check $$((0x11008)) 3e "ROM hook slot"; \
	check $$((0x11100)) a5 "ROM signature"; \
	check $$((0x11101)) 11 "ROM 0101"; \
	check $$((0x19000)) c3 "page0 0"; \
	check $$((0x19006)) 06 "page0 6"; \
	check $$((0x19007)) f2 "page0 7"; \
	check $$((0x19008)) 00 "page0 hook slot"; \
	check $$((0x19100)) 5a "page0 write-through"; \
	check $$((0x279e0)) c3 "page0 CCP"; \
	check $$((0x28206)) c3 "page0 stub"; \
	check $$((0x287d0)) 00 "page0 FAT"; \
	check $$((0x29000)) 00 "page1 0"; \
	check $$((0x38200)) 00 "page1 F200"; \
	check $$((0x379e0)) 00 "page1 CCP"; \
	echo "$(GREEN)ticks_page rc2014 firmware $(CPU) passed$(RESET)"

z180_common: z180_common.bin
	@z88dk-ticks -mz180 -end 7e -output z180_common.out z180_common.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N3 z180_common.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	low=$$(od -An -tx1 -j61696 -N1 z180_common.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(Z180_COMMON)" ] && [ "$$low" = "ab" ]; then \
		echo "$(GREEN)ticks_page z180 common-1 passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page z180 common-1 failed: got '$$got' low '$$low'$(RESET)"; exit 1; \
	fi

# 8085 disk harness. The ROM image and the RAM image include the layout.
# The RAM file name contains rc2014. The hook at 0x0008 stays off.
# -pc 8000 is the runner inside the RAM image.
disk85: disk85_rom.bin rc2014_disk85_ram.bin
	@z88dk-ticks -m8085 -b rc2014 -pc 8000 -end 8100 -output disk85.out -disk disk85_rom.bin rc2014_disk85_ram.bin > disk85.txt
	@grep -qx 'BDOS_DISK_OK' disk85.txt
	@got=$$(od -An -tx1 -j33024 -N6 disk85.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" != "$(DISK85)" ]; then \
		echo "$(RED)ticks_page disk85 failed: got '$$got'$(RESET)"; exit 1; \
	fi
	@check() { \
		got=$$(od -An -tx1 -j "$$1" -N1 disk85.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
		if [ "$$got" != "$$2" ]; then \
			echo "$(RED)ticks_page disk85 $$3: got '$$got'$(RESET)"; exit 1; \
		fi; \
	}; \
	check $$((0x11000)) 00 "ROM 0"; \
	check $$((0x18131)) 42 "ROM literal"; \
	check $$((0x18628)) d1 "ROM fatwin"; \
	check $$((0x18893)) c3 "ROM copy"; \
	check $$((0x18894)) 11 "ROM copy+1"; \
	check $$((0x19000)) 12 "page0 init"; \
	check $$((0x19008)) 00 "page0 hook"; \
	check $$((0x20131)) 00 "page0 literal"; \
	check $$((0x20628)) 77 "page0 fatwin"; \
	check $$((0x20893)) c3 "page0 copy"; \
	check $$((0x21000)) af "page0 runner"; \
	check $$((0x29000)) 00 "page1 0"; \
	check $$((0x30131)) 00 "page1 literal"; \
	check $$((0x31000)) 00 "page1 runner"; \
	echo "$(GREEN)ticks_page disk85 passed$(RESET)"

ez80_ed28: ez80_ed28.bin
	@z88dk-ticks -mez80_z80 -end 0d -output ez80_ed28.out ez80_ed28.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N2 ez80_ed28.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(EZ80_ED28)" ]; then \
		echo "$(GREEN)ticks_page ez80 ED 28 passed$(RESET)"; \
	else \
		echo "$(RED)ticks_page ez80 ED 28 failed: got '$$got'$(RESET)"; exit 1; \
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
	rm -f *.bin *.o *.lis *.out *.sym *.map *.txt zcc_opt.def

.PHONY: all clean z180_auto z180_explicit z180_flat z180_common \
	rc_z80 rc_8085 rc_romsize rc_fw_z80 rc_fw_8085 rc_fw_check \
	disk85 ez80_ed28 zxn_auto zxn_explicit zxn_flat
