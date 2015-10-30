
TARGETS = embedded zx m cpm
TARGETS = cpm

jobs := $(foreach target,$(TARGETS),job-$(target))
cleans := $(foreach target,$(TARGETS),clean-$(target))

.PHONY: all
all: ${jobs} 

target = $(firstword $(subst -, ,$*))

.PHONY: ${jobs}
${jobs}: job-%:
	cp target/$(target)/clib_cfg.asm .
	cp target/$(target)/clib_target_cfg.asm .
	#z80asm -ns -nm -Mo -xlib/$(target)_asm @target/$(target)/library/$(target)_asm.lst
	z80asm -ns -nm -Mo -xlib/$(target)_sccz80 @target/$(target)/library/$(target)_sccz80.lst
	z80asm -ns -nm -Mo -xlib/$(target)_sdcc_ix -D__SDCC -D__SDCC_IX @target/$(target)/library/$(target)_sdcc_ix.lst
	z80asm -ns -nm -Mo -xlib/$(target)_sdcc_iy -D__SDCC -D__SDCC_IY @target/$(target)/library/$(target)_sdcc_iy.lst

.PHONY: ${cleans}
${cleans}: clean-%:
	$(RM) lib/$(target)_asm.lib 
	$(RM) lib/$(target)_sccz80.lib
	$(RM) lib/$(target)_sdcc_ix.lib
	$(RM) lib/$(target)_sdcc_iy.lib

clean:	${cleans}
	$(RM) clib_cfg.asm clib_target_cfg.asm
	find . -name '*.o' | xargs $(RM)
	find . -name '*.err' | xargs $(RM)
