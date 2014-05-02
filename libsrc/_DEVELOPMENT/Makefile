
TARGETS = cpm zx
LIB_TYPES = asm lr_sccz80 sdcc_ix sdcc_iy

jobs := $(foreach target,$(TARGETS),$(foreach type,$(LIB_TYPES),job-$(target)-$(type)))

.PHONY: all
all: ${jobs} 

target = $(firstword $(subst -, ,$*))
type = $(lastword $(subst -, ,$*))

.PHONY: ${jobs}
${jobs}: job-%:
	cp target/$(target)/clib_cfg.asm .
	cp target/$(target)/clib_target_cfg.asm .
	z80asm -ns -nm -Mo -x$(target)_$(type).lib @target/$(target)/library/$(target)_$(type).lst
	mv $(target)_$(type).lib lib


