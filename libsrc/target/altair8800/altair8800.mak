ALTAIR8800_GLOBS := \
	"target/altair8800/stdio/*.asm" 

ALTAIR8800_GLOBS_ex := \
	target/altair8800/stdio/*.asm 


ALTAIR8800_TARGETS := target/altair8800/obj/target-altair8800-altair8800 classic/gfx/obj/.stamp-altair8800
		

CLEAN += target-altair8800-clean

$(eval $(call gfx_stamp_portable,altair8800,altair8800))
ALTAIR_GENCON_VTI_OBJECTS := $(addprefix classic/gfx/gencon/obj/vti/,$(patsubst %.asm,%.o,$(notdir $(wildcard classic/gfx/gencon/*.asm))))
ALTAIR_GENCON_VIO_OBJECTS := $(addprefix classic/gfx/gencon/obj/vio/,$(patsubst %.asm,%.o,$(notdir $(wildcard classic/gfx/gencon/*.asm))))
ALTAIR_GENCON_VDM_OBJECTS := $(addprefix classic/gfx/gencon/obj/vdm/,$(patsubst %.asm,%.o,$(notdir $(wildcard classic/gfx/gencon/*.asm))))

$(eval $(call gfx_stamp_portable_args,vti,TARGET=altair8800 SUBTYPE=vti FLAVOUR=gencon,$(ALTAIR_GENCON_VTI_OBJECTS)))
$(eval $(call gfx_stamp_portable_args,vio,TARGET=altair8800 SUBTYPE=vio FLAVOUR=gencon,$(ALTAIR_GENCON_VIO_OBJECTS)))
$(eval $(call gfx_stamp_portable_args,vdm,TARGET=altair8800 SUBTYPE=vdm FLAVOUR=gencon,$(ALTAIR_GENCON_VDM_OBJECTS)))

target-altair8800: $(ALTAIR8800_TARGETS)

.PHONY: target-altair8800 target-altair8800-clean


$(eval $(call buildtargetasm,target/altair8800,8080,altair8800,-m8080,$(ALTAIR8800_GLOBS),$(ALTAIR8800_GLOBS_ex)))

target-altair8800-clean:
	$(RM) -fr target/altair8800/obj
