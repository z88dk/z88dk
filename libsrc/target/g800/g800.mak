G800_SOURCES := $(shell find target/g800 -type f -name '*.asm')

G800_TARGETS := target/g800/obj/target-g800-g815 target/g800/obj/target-g800-e200 target/g800/obj/target-g800-g850 \
	classic/games/obj/.stamp-g800-g815 classic/games/obj/.stamp-g800-e200 classic/games/obj/.stamp-g800-g850 \
	classic/gfx/obj/.stamp-g800 classic/gfx/obj/.stamp-g800-g815 classic/gfx/obj/.stamp-g800-e200 classic/gfx/obj/.stamp-g800-g850

CLEAN += target-g800-clean

$(eval $(call gfx_stamp_args,g800,TARGET=g800))
$(eval $(call gfx_stamp_args,g800-g815,TARGET=g800 FLAVOUR=narrow SUBTYPE=g815))
$(eval $(call gfx_stamp_args,g800-e200,TARGET=g800 FLAVOUR=narrow SUBTYPE=e200))
$(eval $(call gfx_stamp_args,g800-g850,TARGET=g800 FLAVOUR=narrow SUBTYPE=g850))

target-g800: $(G800_TARGETS)

.PHONY: target-g800 target-g800-clean

define g800_asm
target/g800/obj/target-g800-$(1): $(G800_SOURCES)
	@mkdir -p target/g800/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/g800/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/g800 -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/g800/def -Itarget/g800 -Itarget/g800/obj/$(1) -I$$(Z88DK_LIBSRC)/classic -mz80 -D__CLASSIC -DFOR$(1) $$(G800_SOURCES)
	$$(Q)touch $$@
endef

$(foreach variant,g815 e200 g850,$(eval $(call g800_asm,$(variant))))

target-g800-clean:
	$(RM) -fr target/g800/obj
