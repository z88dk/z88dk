PV1000_GLOBS := \
	"target/pv1000/games/*.asm" \
	"target/pv1000/graphics/*.asm" \
	"target/pv1000/stdio/*.asm" 

PV1000_GLOBS_ex := \
	target/pv1000/games/*.asm \
	target/pv1000/graphics/*.asm \
	target/pv1000/stdio/*.asm 


PV1000_TARGETS := target/pv1000/obj/target-pv1000-pv1000 classic/games/obj/.stamp-pv1000 classic/gfx/obj/.stamp-pv1000
		

CLEAN += target-pv1000-clean
TOCREATE += $(call check_target,pv1000,pv1000_clib.lib)

$(eval $(call gfx_stamp_args,pv1000,TARGET=pv1000 FLAVOUR="gencon narrow"))
$(eval $(call buildtargetasm,target/pv1000,z80,pv1000,-mz80,$(PV1000_GLOBS),$(PV1000_GLOBS_ex)))

pv1000_clib.lib: $(TARGET_CLIB_DEPS) $(PV1000_TARGETS)
	TARGET=pv1000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpv1000 -x$(OUTPUT_DIRECTORY)/pv1000_clib @$(TARGET_DIRECTORY)/pv1000/pv1000.lst


target-pv1000: $(PV1000_TARGETS)

.PHONY: target-pv1000 target-pv1000-clean



target-pv1000-clean:
	$(RM) -fr target/pv1000/obj
