ALTAIR8800_GLOBS := \
	"target/altair8800/stdio/*.asm" 

ALTAIR8800_GLOBS_ex := \
	target/altair8800/stdio/*.asm 


ALTAIR8800_TARGETS := target/altair8800/obj/target-altair8800-altair8800 classic/gfx/obj/.stamp-altair8800
		

CLEAN += target-altair8800-clean
TOCREATE += $(call check_target,altair8800,altair8800_clib.lib gfxvti.lib gfxvdm.lib)
$(eval $(call gfx_stamp_portable,altair8800,altair8800))
ALTAIR_GENCON_VTI_OBJECTS := $(addprefix classic/gfx/gencon/obj/vti/,$(patsubst %.asm,%.o,$(notdir $(wildcard classic/gfx/gencon/*.asm))))
ALTAIR_GENCON_VIO_OBJECTS := $(addprefix classic/gfx/gencon/obj/vio/,$(patsubst %.asm,%.o,$(notdir $(wildcard classic/gfx/gencon/*.asm))))
ALTAIR_GENCON_VDM_OBJECTS := $(addprefix classic/gfx/gencon/obj/vdm/,$(patsubst %.asm,%.o,$(notdir $(wildcard classic/gfx/gencon/*.asm))))
$(eval $(call gfx_stamp_portable_args,vti,TARGET=altair8800 SUBTYPE=vti FLAVOUR=gencon,$(ALTAIR_GENCON_VTI_OBJECTS)))
$(eval $(call gfx_stamp_portable_args,vio,TARGET=altair8800 SUBTYPE=vio FLAVOUR=gencon,$(ALTAIR_GENCON_VIO_OBJECTS)))
$(eval $(call gfx_stamp_portable_args,vdm,TARGET=altair8800 SUBTYPE=vdm FLAVOUR=gencon,$(ALTAIR_GENCON_VDM_OBJECTS)))
$(eval $(call buildtargetasm,target/altair8800,8080,altair8800,-m8080,$(ALTAIR8800_GLOBS),$(ALTAIR8800_GLOBS_ex)))

altair8800_clib.lib: $(TARGET_CLIB_DEPS) $(ALTAIR8800_TARGETS)
	@echo ''
	@echo '--- Building Altair8800 Library ---'
	@echo ''
	TARGET=altair8800 TYPE=8080 $(LIBLINKER) -m8080 -DFORaltair8800 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/altair8800_clib @$(TARGET_DIRECTORY)/altair8800/altair8800.lst

gfxvti.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-vti
	@echo ''
	@echo '--- Building VTI graphics Library ---'
	@echo ''
	TARGET=vti TYPE=8080 $(LIBLINKER) -m8080 -DFORvti -x$(OUTPUT_DIRECTORY)/gfxvti @$(Z88DK_LIBSRC)/classic/video/vti/video_vti.lst

gfxvio.lib:  $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-vio
	TARGET=vio TYPE=8080 $(LIBLINKER) -m8080 -DFORvio -x$(OUTPUT_DIRECTORY)/gfxvio @$(Z88DK_LIBSRC)/classic/video/vio/video_vio.lst
	@touch $@

gfxvdm.lib:  $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-vdm
	TARGET=vdm TYPE=8080 $(LIBLINKER) -m8080 -DFORvdm -x$(OUTPUT_DIRECTORY)/gfxvdm @$(Z88DK_LIBSRC)/classic/video/vdm/video_vdm.lst
	@touch $@




target-altair8800: $(ALTAIR8800_TARGETS)

.PHONY: target-altair8800 target-altair8800-clean



target-altair8800-clean:
	$(RM) -fr target/altair8800/obj
