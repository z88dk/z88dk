# Target library graphics sub-builds.
#
# Keep the stamp separate from the objects while the existing .lst files
# still use obj/${TARGET} paths. This file owns the recursive gfx build
# definitions; libsrc/Makefile only names the stamps as prerequisites.

GFX_STAMP_SOURCES := $(shell find classic/gfx -type f \( -name '*.asm' -o -name '*.c' -o -name 'Makefile' \))

define gfx_stamp
classic/gfx/obj/.stamp-$(1)-$(2): $(GFX_STAMP_SOURCES)
	$(Q)mkdir -p $$(dir $$@)
	$(MAKE) -C classic/gfx TARGET=$(1) FLAVOUR=$(2)
	@touch $$@
endef

define gfx_stamp_args
classic/gfx/obj/.stamp-$(1): $(GFX_STAMP_SOURCES) $(if $(findstring portable,$(2)),$(GFXPORTABLE_OBJS))
	$(Q)mkdir -p $$(dir $$@)
	$(MAKE) -C classic/gfx $(2)
	@touch $$@
endef

define gfx_stamp_portable
classic/gfx/obj/.stamp-$(1): $(GFX_STAMP_SOURCES) $(GFXPORTABLE_OBJS)
	$(Q)mkdir -p $$(dir $$@)
	$(MAKE) -C classic/gfx TARGET=$(2) $(if $(3),SUBTYPE=$(3)) FLAVOUR=common
	@touch $$@
endef

define gfx_stamp_portable_args
GFX_STAMP_$(1)_MISSING := $(filter-out $(wildcard $(3)),$(3))
classic/gfx/obj/.stamp-$(1): $(GFX_STAMP_SOURCES) $(GFXPORTABLE_OBJS) $$(if $$(GFX_STAMP_$(1)_MISSING),gfx-stamp-missing-$(1))
	$(Q)mkdir -p $$(dir $$@)
	$(MAKE) -C classic/gfx $(2)
	@touch $$@
gfx-stamp-missing-$(1):
.PHONY: gfx-stamp-missing-$(1)
endef
