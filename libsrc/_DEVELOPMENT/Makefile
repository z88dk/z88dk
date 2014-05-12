
TARGETS = cpm zx
LIB_TYPES = asm sccz80 sdcc_ix sdcc_iy

jobs := $(foreach target,$(TARGETS),$(foreach type,$(LIB_TYPES),job-$(target)-$(type)))
cleans := $(foreach target,$(TARGETS),$(foreach type,$(LIB_TYPES),clean-$(target)-$(type)))

.PHONY: all
all: ${jobs} 

target = $(firstword $(subst -, ,$*))
type = $(lastword $(subst -, ,$*))

.PHONY: ${jobs}
${jobs}: job-%:
	cp target/$(target)/clib_cfg.asm .
	cp target/$(target)/clib_target_cfg.asm .
	z80asm -ns -nm -Mo -xlib/$(target)_$(type).lib @target/$(target)/library/$(target)_$(type).lst

.PHONY: ${cleans}
${cleans}: clean-%:
	$(RM) $(target)_$(type).lib 


clean:	${cleans}
	$(RM) clib_cfg.asm clib_target_cfg.asm
	find . -name '*.o' | xargs $(RM)
	find . -name '*.err' | xargs $(RM)
