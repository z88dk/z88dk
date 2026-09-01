ALTAIR8800_GLOBS := \
	"target/altair8800/stdio/*.asm" 

ALTAIR8800_GLOBS_ex := \
	target/altair8800/stdio/*.asm 


ALTAIR8800_TARGETS := target/altair8800/obj/target-altair8800-altair8800 classic/gfx/obj/.stamp-altair8800
		

CLEAN += target-altair8800-clean

$(eval $(call gfx_stamp_args,altair8800,TARGET=altair8800 FLAVOUR=portable))
$(eval $(call gfx_stamp_args,vti,TARGET=altair8800 SUBTYPE=vti FLAVOUR="gencon portable"))
$(eval $(call gfx_stamp_args,vio,TARGET=altair8800 SUBTYPE=vio FLAVOUR="gencon portable"))
$(eval $(call gfx_stamp_args,vdm,TARGET=altair8800 SUBTYPE=vdm FLAVOUR="gencon portable"))

target-altair8800: $(ALTAIR8800_TARGETS)

.PHONY: target-altair8800 target-altair8800-clean


$(eval $(call buildtargetasm,target/altair8800,8080,altair8800,-m8080,$(ALTAIR8800_GLOBS),$(ALTAIR8800_GLOBS_ex)))

target-altair8800-clean:
	$(RM) -fr target/altair8800/obj
