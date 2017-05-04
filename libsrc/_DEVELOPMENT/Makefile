
TARGET ?= z80 cpm m rc2014 sms z180 zx

jobs := $(foreach target,$(TARGET),job-$(target))
cleans := $(foreach target,$(TARGET),clean-$(target))

.PHONY: all
all: ${jobs} 

target = $(firstword $(subst -, ,$*))

.PHONY: ${jobs}
${jobs}: job-%:
	$(eval cpu := $(shell \
		if [ "$(target)" = "z180" ]; then \
			echo "--cpu=z180"; \
		else \
			echo "";  \
		fi) )
	m4 -DCFG_ASM_DEF target/$(target)/config.m4 > target/$(target)/config_$(target)_private.inc
	m4 -DCFG_ASM_PUB target/$(target)/config.m4 > target/$(target)/config_$(target)_public.inc
	m4 -DCFG_C_DEF target/$(target)/config.m4 > target/$(target)/config_$(target).h
	cp target/$(target)/config_$(target)_private.inc config_private.inc
	@if [ "$(target)" = "zx" ]; then \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DSTRIPVECTOR" arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DPLUS3 -DSTRIPVECTOR" arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
		zx7 -f arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		zx7 -f arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
	fi;
	@if [ -f target/$(target)/library/$(target)_macro.lst ]; then \
		zcc +z80 -vn -clib=new -m4 --lstcwd @target/$(target)/library/$(target)_macro.lst; \
	fi;
	z80asm $(cpu) -xlib/sccz80/$(target) @target/$(target)/library/$(target)_sccz80.lst
	z80asm $(cpu) -xlib/sdcc_ix/$(target) -D__SDCC -D__SDCC_IX @target/$(target)/library/$(target)_sdcc_ix.lst
	z80asm $(cpu) --IXIY -xlib/sdcc_iy/$(target) -D__SDCC -D__SDCC_IY @target/$(target)/library/$(target)_sdcc_iy.lst

.PHONY: ${cleans}
${cleans}: clean-%:
	$(RM) lib/sccz80/$(target).lib
	$(RM) lib/sdcc_ix/$(target).lib
	$(RM) lib/sdcc_iy/$(target).lib

install-clean:
	find . -name '*.o' | xargs $(RM)
	find . -name '*.err' | xargs $(RM)

clean:	${cleans}
	$(RM) config_private.inc zcc_opt.def
	find . -name '*.o' | xargs $(RM)
	find . -name '*.err' | xargs $(RM)
