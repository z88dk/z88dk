# Target library graphics sub-builds.
#
# Keep the stamp separate from the objects while the existing .lst files
# still use obj/${TARGET} paths. This file owns the recursive gfx build
# definitions; libsrc/Makefile only names the stamps as prerequisites.

GFX_STAMP_SOURCES := $(shell find classic/gfx -type f \( -name '*.asm' -o -name '*.c' -o -name 'Makefile' \))

define gfx_stamp
classic/gfx/obj/.stamp-$(1)-$(2): $(GFX_STAMP_SOURCES)
	@mkdir -p $$(dir $$@)
	$(MAKE) -C classic/gfx TARGET=$(1) FLAVOUR=$(2)
	@touch $$@
endef

define gfx_stamp_args
classic/gfx/obj/.stamp-$(1): $(GFX_STAMP_SOURCES) $(if $(findstring portable,$(2)),$(GFXPORTABLE_OBJS))
	@mkdir -p $$(dir $$@)
	$(MAKE) -C classic/gfx $(2)
	@touch $$@
endef
