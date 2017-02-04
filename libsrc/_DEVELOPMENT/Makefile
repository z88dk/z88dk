
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
	@if [ "$(target)" = "zx" ]; then \
		zcc +zx -vn -clib=new --no-crt -g -Ca"-DSTRIPVECTOR" arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		zcc +zx -vn -clib=new --no-crt -g -Ca"-DPLUS3 -DSTRIPVECTOR" arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
		zx7 -f arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		zx7 -f arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
		zcc +zx -vn -m4 arch/zx/bifrost2/z80/BIFROST2_INSTALL.asm.m4; \
		zcc +zx -vn -m4 arch/zx/nirvanam/z80/asm_NIRVANAM.asm.m4; \
		zcc +zx -vn -m4 arch/zx/nirvanap/z80/asm_NIRVANAP.asm.m4; \
	fi;
	z80asm -xlib/sccz80/$(target) @target/$(target)/library/$(target)_sccz80.lst
	z80asm -xlib/sdcc_ix/$(target) -D__SDCC -D__SDCC_IX @target/$(target)/library/$(target)_sdcc_ix.lst
	z80asm --IXIY -xlib/sdcc_iy/$(target) -D__SDCC -D__SDCC_IY @target/$(target)/library/$(target)_sdcc_iy.lst

.PHONY: ${cleans}
${cleans}: clean-%:
	$(RM) lib/sccz80/$(target).lib
	$(RM) lib/sdcc_ix/$(target).lib
	$(RM) lib/sdcc_iy/$(target).lib

clean:	${cleans}
	$(RM) clib_cfg.asm clib_target_cfg.asm
	find . -name '*.o' | xargs $(RM)
	find . -name '*.err' | xargs $(RM)
