
Z80ASM = $(EXEC_PREFIX)z80asm
ZX7 = z88dk-zx7

TARGET ?= z80 cpm m math32 math32_z180 math32_z80n rc2014 sms vgl yaz180 z180 zx zxn

jobs := $(foreach target,$(TARGET),job-$(target))
cleans := $(foreach target,$(TARGET),clean-$(target))

.PHONY: all
all: ${jobs} 

target = $(firstword $(subst -, ,$*))

.PHONY: ${jobs}
${jobs}: job-%:
	$(eval cpu := $(shell \
		if [ "$(target)" = "z180" ]; then \
			echo "-mz180"; \
		elif \
			[ "$(target)" = "yaz180" ]; then \
			echo "-mz180"; \
		elif \
			[ "$(target)" = "zxn" ]; then \
			echo "-mz80n"; \
		elif \
			[ "$(target)" = "math32_z180" ]; then \
			echo "-mz180"; \
		elif \
			[ "$(target)" = "math32_z80n" ]; then \
			echo "-mz80n"; \
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
		$(ZX7) -f arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		$(ZX7) -f arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
	fi;
	@if [ "$(target)" = "zxn" ]; then \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DSTRIPVECTOR" arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		zcc +z80 -vn -clib=new --no-crt -g -Ca"-DPLUS3 -DSTRIPVECTOR" arch/zx/bifrost2/z80/BIFROST2_ENGINE.asm.m4 -o arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
		$(ZX7) -f arch/zx/bifrost2/z80/bifrost2_engine_48.bin; \
		$(ZX7) -f arch/zx/bifrost2/z80/bifrost2_engine_p3.bin; \
	fi;
	@if [ -f target/$(target)/library/$(target)_macro.lst ]; then \
		zcc +z80 -vn -clib=new -m4 --lstcwd @target/$(target)/library/$(target)_macro.lst; \
	fi;
	$(Z80ASM) $(cpu) -xlib/sccz80/$(target) @target/$(target)/library/$(target)_sccz80.lst
	$(Z80ASM) $(cpu) -xlib/sdcc_ix/$(target) -D__SDCC -D__SDCC_IX @target/$(target)/library/$(target)_sdcc_ix.lst
	$(Z80ASM) $(cpu) --IXIY -xlib/sdcc_iy/$(target) -D__SDCC -D__SDCC_IY @target/$(target)/library/$(target)_sdcc_iy.lst

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
