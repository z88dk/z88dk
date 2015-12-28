
TARGET ?= embedded zx m cpm

jobs := $(foreach target,$(TARGET),job-$(target))
cleans := $(foreach target,$(TARGET),clean-$(target))

.PHONY: all
all: ${jobs} 

target = $(firstword $(subst -, ,$*))


.PHONY: ${jobs}
${jobs}: job-%:
	-@cp target/$(target)/clib_cfg.asm  . 2> /dev/null
	-@cp target/$(target)/clib_target_cfg.asm . 2> /dev/null
	z80asm -ns -nm -Mo -xlib/sccz80/$(target) @target/$(target)/library/$(target)_sccz80.lst
	z80asm -ns -nm -Mo -xlib/sdcc_ix/$(target) -D__SDCC -D__SDCC_IX @target/$(target)/library/$(target)_sdcc_ix.lst
	z80asm -ns -nm -Mo -IXIY -xlib/sdcc_iy/$(target) -D__SDCC -D__SDCC_IY @target/$(target)/library/$(target)_sdcc_iy.lst

.PHONY: ${cleans}
${cleans}: clean-%:
	$(RM) lib/sccz80/$(target).lib
	$(RM) lib/sdcc_ix/$(target).lib
	$(RM) lib/sdcc_iy/$(target).lib

clean:	${cleans}
	$(RM) clib_cfg.asm clib_target_cfg.asm
	find . -name '*.o' | xargs $(RM)
	find . -name '*.err' | xargs $(RM)
