G800_SOURCES := $(call rwildcard,target/g800,*.asm)

G800_GRAPHICS_SOURCES := $(wildcard target/g800/graphics/*.asm)
G800_GRAPHICS_OBJECTS := $(foreach variant,g815 e200 g850,$(patsubst target/g800/graphics/%,target/g800/graphics/obj/$(variant)/%,$(G800_GRAPHICS_SOURCES:.asm=.o)))

G800_TARGETS := target/g800/obj/target-g800-g815 target/g800/obj/target-g800-e200 target/g800/obj/target-g800-g850 \
	classic/games/obj/.stamp-g800-g815 classic/games/obj/.stamp-g800-e200 classic/games/obj/.stamp-g800-g850 \
	classic/gfx/obj/.stamp-g800 classic/gfx/obj/.stamp-g800-g815 classic/gfx/obj/.stamp-g800-e200 classic/gfx/obj/.stamp-g800-g850 \
	$(G800_GRAPHICS_OBJECTS)

CLEAN += target-g800-clean
TOCREATE += $(call check_target,g850,g850_clib.lib e200_clib.lib g815_clib.lib g815b.lib g850b.lib)

$(eval $(call gfx_stamp_args,g800,TARGET=g800))
$(eval $(call gfx_stamp_args,g800-g815,TARGET=g800 FLAVOUR=narrow SUBTYPE=g815))
$(eval $(call gfx_stamp_args,g800-e200,TARGET=g800 FLAVOUR=narrow SUBTYPE=e200))
$(eval $(call gfx_stamp_args,g800-g850,TARGET=g800 FLAVOUR=narrow SUBTYPE=g850))
define g800_asm
target/g800/obj/target-g800-$(1): $(G800_SOURCES)
	$(Q)mkdir -p target/g800/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/g800/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/g800 -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/g800/def -Itarget/g800 -Itarget/g800/obj/$(1) -I$$(Z88DK_LIBSRC)/classic -mz80 -DSTANDARDESCAPECHARS -D__CLASSIC -DFOR$(1) $$(G800_SOURCES)
	$$(Q)touch $$@
endef
$(foreach variant,g815 e200 g850,$(eval $(call g800_asm,$(variant))))
define g800_graphics_asm
target/g800/graphics/obj/$(1)/%.o: target/g800/graphics/%.asm
	$(Q)mkdir -p $$(dir $$@)
	$$(Q)$$(ASSEMBLER) -DFOR$(1) -I$$(Z88DK_LIB) -DSTANDARDESCAPECHARS -o=$$@ $$<
endef
$(foreach variant,g815 e200 g850,$(eval $(call g800_graphics_asm,$(variant))))

e200_clib.lib: $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=e200 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/e200_clib @$(TARGET_DIRECTORY)/g800/g800.lst

g815_clib.lib: $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=g815 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g815_clib @$(TARGET_DIRECTORY)/g800/g815.lst

g815b.lib: g815_clib.lib $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=g815 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g815b @$(TARGET_DIRECTORY)/g800/g800.lst
	@touch $@

g850_clib.lib: $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=g850 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g850_clib @$(TARGET_DIRECTORY)/g800/g850.lst
	@touch $@

g850b.lib: g850_clib.lib $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=g850 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g850b @$(TARGET_DIRECTORY)/g800/g850b.lst
	@touch $@


target-g800: $(G800_TARGETS)

.PHONY: target-g800 target-g800-clean





target-g800-clean:
	$(RM) -fr target/g800/obj
