# Classic video objects, built directly into libsrc's dependency graph.

TMS9918_VIDEO_SUBDIRS := graphics stdio/ansi stdio/generic_console
UPD7220_VIDEO_SUBDIRS := gencon
KRT_VIDEO_SUBDIRS := stdio graphics
MC6847_VIDEO_SUBDIRS := stdio graphics

video_asm_sources = $(wildcard classic/video/$(2)/*.asm $(addsuffix /*.asm,$(addprefix classic/video/$(2)/,$($(1)_VIDEO_SUBDIRS))))
video_c_sources = $(wildcard classic/video/$(2)/*.c $(addsuffix /*.c,$(addprefix classic/video/$(2)/,$($(1)_VIDEO_SUBDIRS))))

video_object_path = $(if $(filter krt msm6255,$(1)),classic/video/$(1)/obj/$(2)/$(patsubst classic/video/$(1)/%,%,$(basename $(3))).o,$(dir $(3))obj/$(2)/$(notdir $(basename $(3))).o)
video_asm_objects = $(foreach s,$(call video_asm_sources,$(2),$(1)),$(call video_object_path,$(1),$(3),$(s)))
video_c_objects = $(foreach s,$(call video_c_sources,$(2),$(1)),$(call video_object_path,$(1),$(3),$(s)))
video_objects = $(call video_asm_objects,$(1),$(2),$(3)) $(call video_c_objects,$(1),$(2),$(3))

define video_direct_asm_rules

$(foreach s,$(call video_asm_sources,$(2),$(1)),$(call video_object_path,$(1),$(3),$(s)): $(s)
	$$(Q)mkdir -p $$(@D)
	$$(Q)$$(ASSEMBLER) -DFOR$(3) -I$$(Z88DK_LIBSRC) -I$$(Z88DK_LIB) -Iclassic/video/$(1) -o=$$@ $$<
)
endef

define video_zcc_asm_rules

$(foreach s,$(call video_asm_sources,$(2),$(1)),$(call video_object_path,$(1),$(3),$(s)): $(s)
	$$(Q)mkdir -p $$(@D)
	$$(ZCC) +$(4) $(if $(5),-subtype=$(5)) -Ca-DFOR$(3) -Ca-I$$(Z88DK_LIBSRC) -Ca-I$$(Z88DK_LIB) -c -o $$@ $$<
)
endef

define video_c_rules

$(foreach s,$(call video_c_sources,$(2),$(1)),$(call video_object_path,$(1),$(3),$(s)): $(s)
	$$(Q)mkdir -p $$(@D)
	$$(ZCC) +$(4) $(if $(5),-subtype=$(5)) -Iclassic/video/$(1) -c -o $$@ $$<
)
endef

define video_rules
$(if $(filter krt msm6255,$(1)),$(call video_zcc_asm_rules,$(1),$(2),$(3),$(4),$(5)),$(call video_direct_asm_rules,$(1),$(2),$(3)))
$(call video_c_rules,$(1),$(2),$(3),$(4),$(5))
endef

# $(1) = video module, $(2) = module variable prefix, $(3) = zcc target,
# $(4) = optional subtype. The directory target is retained as an aggregate
# dependency for target .mak files; object rules create it as needed.
define buildvideo
classic/video/$(1)/obj/$(or $(4),$(3)): $(call video_objects,$(1),$(2),$(or $(4),$(3)))
$(if $(VIDEO_RULE_$(1)_$(or $(4),$(3))),,$(eval VIDEO_RULE_$(1)_$(or $(4),$(3)) := 1)$(call video_rules,$(1),$(2),$(or $(4),$(3)),$(3),$(4)))
endef

$(eval $(call buildvideo,tek401x,TEK401X,test,))
$(eval $(call buildvideo,regis,REGIS,test,))

gfxtek.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-tek classic/video/tek401x/obj/test
	@echo ''
	@echo '--- Building TEK4010 graphics Library ---'
	@echo ''
	TARGET=tek TYPE=z80 $(LIBLINKER) -mz80 -DFORtek -x$(OUTPUT_DIRECTORY)/gfxtek @$(Z88DK_LIBSRC)/classic/video/tek401x/video_tek.lst

gfxregis.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-regis classic/video/regis/obj/test
	@echo ''
	@echo '--- Building ReGIS graphics Library ---'
	@echo ''
	TARGET=regis TYPE=z80 $(LIBLINKER) -mz80 -DFORregis -x$(OUTPUT_DIRECTORY)/gfxregis @$(Z88DK_LIBSRC)/classic/video/regis/video_regis.lst
