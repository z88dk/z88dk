include ../make.config

# 28-bit IDE LBA byte offset. POSIX truncate and dd. Skipped on Windows.

UNAME := $(shell uname -s 2>/dev/null)
IDE_WINDOWS :=
ifeq ($(OS),Windows_NT)
IDE_WINDOWS := 1
endif
ifneq (,$(findstring CYGWIN,$(UNAME)))
IDE_WINDOWS := 1
endif
ifneq (,$(findstring MINGW,$(UNAME)))
IDE_WINDOWS := 1
endif
ifneq (,$(findstring MSYS,$(UNAME)))
IDE_WINDOWS := 1
endif

# 2^37 bytes. The last LBA is 0x0FFFFFFF.
IMG := /tmp/ticks-ide-128.img
SIZE := 137438953472

ifdef IDE_WINDOWS
all:
	@echo "ticks_ide: skipped (POSIX-shell recipes; not run on Windows)"
else
all: ide_lba
endif

ide_read.bin: ide_read.asm
	z88dk-z80asm -mz80 -b ide_read.asm

ide_lba: ide_read.bin
	rm -f $(IMG)
	truncate -s $(SIZE) $(IMG)
	printf 'M03FFFFF' | dd of=$(IMG) bs=512 seek=4194303 conv=notrunc status=none
	printf 'M0400000' | dd of=$(IMG) bs=512 seek=4194304 conv=notrunc status=none
	printf 'M07FFFFF' | dd of=$(IMG) bs=512 seek=8388607 conv=notrunc status=none
	printf 'M0800000' | dd of=$(IMG) bs=512 seek=8388608 conv=notrunc status=none
	printf 'M0FFFFFF' | dd of=$(IMG) bs=512 seek=268435455 conv=notrunc status=none
	z88dk-ticks -mz80 -b rc2014 -end 44 -ide0 $(IMG) ide_read.bin > ide_lba.txt
	head -n 5 ide_lba.txt > ide_lba.got
	printf '%s\n' M03FFFFF M0400000 M07FFFFF M0800000 M0FFFFFF > ide_lba.exp
	cmp ide_lba.exp ide_lba.got; st=$$?; rm -f $(IMG); exit $$st
	@echo "$(GREEN)ticks_ide lba offset passed$(RESET)"

clean:
	rm -f *.bin *.o *.lis *.sym *.map *.txt *.exp *.got $(IMG) zcc_opt.def

.PHONY: all clean ide_lba
