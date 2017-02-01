
TARGET ?= cpm embedded m rc2014 sms z180 zx

jobs := $(foreach target,$(TARGET),job-$(target))
cleans := $(foreach target,$(TARGET),clean-$(target))

.PHONY: all
all: ${jobs} 

target = $(firstword $(subst -, ,$*))


.PHONY: ${jobs}
${jobs}: job-%:
	-@cp target/$(target)/clib_cfg.asm  . 2> /dev/null
	-@cp target/$(target)/clib_target_cfg.asm . 2> /dev/null
	zcc +embedded -vn -clib=new --lstcwd -x @target/$(target)/library/$(target)_sccz80.lst -o lib/sccz80/$(target)
	zcc +embedded -vn -clib=sdcc_ix --lstcwd -x @target/$(target)/library/$(target)_sdcc_ix.lst -o lib/sdcc_ix/$(target)
	zcc +embedded -vn -clib=sdcc_iy --lstcwd -Ca--IXIY -x @target/$(target)/library/$(target)_sdcc_iy.lst -o lib/sdcc_iy/$(target)

.PHONY: ${cleans}
${cleans}: clean-%:
	$(RM) lib/sccz80/$(target).lib
	$(RM) lib/sdcc_ix/$(target).lib
	$(RM) lib/sdcc_iy/$(target).lib

clean:	${cleans}
	$(RM) clib_cfg.asm clib_target_cfg.asm
	find . -name '*.o' | xargs $(RM)
	find . -name '*.err' | xargs $(RM)
