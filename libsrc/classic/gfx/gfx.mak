# Target library graphics sub-builds.

gfx_cobjects = $(notdir $(wildcard classic/gfx/$(1)/*.c))
gfx_asmobjects = $(notdir $(wildcard classic/gfx/$(1)/*.asm))
gfx_objects = $(addprefix classic/gfx/$(1)/obj/$(2)/,$(patsubst %.c,%.o,$(call gfx_cobjects,$(1))) $(patsubst %.asm,%.o,$(call gfx_asmobjects,$(1))))

define gfx_object_rules
classic/gfx/$(1)/obj/$(2):
	$$(Q)mkdir -p $$@

classic/gfx/$(1)/obj/$(2)/%.o: classic/gfx/$(1)/%.c | classic/gfx/$(1)/obj/$(2)
	$$(ZCC) +$(3) $$(CFLAGS) $(4) -Iclassic/gfx/$(1) -o $$@ $$^

classic/gfx/$(1)/obj/$(2)/%.o: classic/gfx/$(1)/%.asm | classic/gfx/$(1)/obj/$(2)
	$$(ZCC) +$(3) $$(CFLAGS) $(4) -o $$@ -O0 $$^ -Ca-I$$(Z88DK_LIBSRC) -Ca-DFOR$(5)
endef

define gfx_stamp_objects
$(foreach gfxdir,$(1),$(call gfx_objects,$(gfxdir),$(2)))
endef

gfx_arg_target = $(patsubst TARGET=%,%,$(filter TARGET=%,$(1)))
gfx_arg_subtype = $(patsubst SUBTYPE=%,%,$(filter SUBTYPE=%,$(1)))
gfx_arg_cflags = $(subst ",,$(patsubst TARGET_CFLAGS=%,%,$(filter TARGET_CFLAGS=%,$(1))))
gfx_arg_flavour = $(shell echo '$(1)' | awk 'match($$0,/FLAVOUR="[^"]*"/) { print substr($$0,RSTART+9,RLENGTH-10); exit } match($$0,/FLAVOUR=[^ ]+/) { print substr($$0,RSTART+8,RLENGTH-8); exit }')

define gfx_stamp
classic/gfx/obj/.stamp-$(1)-$(2): $(call gfx_stamp_objects,common $(2),$(1))
	$(Q)touch $$@
$(foreach gfxdir,common $(2),$(if $(GFX_RULE_$(gfxdir)_$(1)),,$(eval GFX_RULE_$(gfxdir)_$(1) := 1)$(eval $(call gfx_object_rules,$(gfxdir),$(1),$(1),,$(1)))))
endef

define gfx_stamp_args
classic/gfx/obj/.stamp-$(1): $(call gfx_stamp_objects,common $(or $(call gfx_arg_flavour,$(2)),narrow),$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2)))) $(if $(findstring portable,$(or $(call gfx_arg_flavour,$(2)),narrow)),$(GFXPORTABLE_OBJS))
	$(Q)touch $$@
$(foreach gfxdir,common $(or $(call gfx_arg_flavour,$(2)),narrow),$(if $(GFX_RULE_$(gfxdir)_$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2)))),,$(eval GFX_RULE_$(gfxdir)_$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2))) := 1)$(eval $(call gfx_object_rules,$(gfxdir),$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2))),$(call gfx_arg_target,$(2)),$(call gfx_arg_cflags,$(2)),$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2)))))))
endef

define gfx_stamp_portable
classic/gfx/obj/.stamp-$(1): $(call gfx_stamp_objects,common,$(or $(3),$(2))) $(GFXPORTABLE_OBJS)
	$(Q)touch $$@
$(if $(GFX_RULE_common_$(or $(3),$(2))),,$(eval GFX_RULE_common_$(or $(3),$(2)) := 1)$(eval $(call gfx_object_rules,common,$(or $(3),$(2)),$(2),,$(or $(3),$(2)))))
endef
define gfx_stamp_portable_args
classic/gfx/obj/.stamp-$(1): $(call gfx_stamp_objects,common $(or $(call gfx_arg_flavour,$(2)),narrow),$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2)))) $(GFXPORTABLE_OBJS) $(3)
	$(Q)touch $$@
$(foreach gfxdir,common $(or $(call gfx_arg_flavour,$(2)),narrow),$(if $(GFX_RULE_$(gfxdir)_$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2)))),,$(eval GFX_RULE_$(gfxdir)_$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2))) := 1)$(eval $(call gfx_object_rules,$(gfxdir),$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2))),$(call gfx_arg_target,$(2)),$(call gfx_arg_cflags,$(2)),$(or $(call gfx_arg_subtype,$(2)),$(call gfx_arg_target,$(2)))))))
endef
