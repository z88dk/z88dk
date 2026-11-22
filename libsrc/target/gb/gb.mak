GB_SOURCES := $(call rwildcard,target/gb,*.asm)

GB_TARGETS := target/gb/obj/target-gb-gb classic/games/obj/.stamp-gb classic/gfx/obj/.stamp-gb

CLEAN += target-gb-clean
TOCREATE += $(call check_target,gb,gb_clib.lib)

$(eval $(call gfx_stamp_portable_args,gb,TARGET=gb FLAVOUR=gencon))
$(eval $(call buildtargetasm,target/gb,gbz80,gb,-mgbz80,$(GB_SOURCES),$(GB_SOURCES)))

gb_clib.lib: $(TARGET_CLIB_DEPS) $(GB_TARGETS)
	TARGET=gb TYPE=gbz80 $(LIBLINKER) -mgbz80 -DFORgb -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gb_clib @$(TARGET_DIRECTORY)/gb/gb.lst


target-gb: $(GB_TARGETS)

.PHONY: target-gb target-gb-clean


target-gb-clean:
	$(RM) -fr target/gb/obj
