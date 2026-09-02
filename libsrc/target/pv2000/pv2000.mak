PV2000_GLOBS := \
	"target/pv2000/input/*.asm" 

PV2000_GLOBS_ex := \
	target/pv2000/input/*.asm 


PV2000_TARGETS := target/pv2000/obj/target-pv2000-pv2000 classic/video/tms9918/obj/pv2000 classic/games/obj/.stamp-pv2000 classic/gfx/obj/.stamp-pv2000
		

CLEAN += target-pv2000-clean
TOCREATE += $(call check_target,pv2000,pv2000_clib.lib)

pv2000_clib.lib: $(TARGET_CLIB_DEPS) $(PV2000_TARGETS)
	$(MAKE) -C classic/video/tms9918 TARGET=pv2000
	TARGET=pv2000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpv2000 -x$(OUTPUT_DIRECTORY)/pv2000_clib @$(TARGET_DIRECTORY)/pv2000/pv2000.lst

$(eval $(call gfx_stamp_args,pv2000,TARGET=pv2000))

target-pv2000: $(PV2000_TARGETS)

.PHONY: target-pv2000 target-pv2000-clean

$(eval $(call buildtms9918,pv2000,pv2000))


$(eval $(call buildtargetasm,target/pv2000,z80,pv2000,-mz80,$(PV2000_GLOBS),$(PV2000_GLOBS_ex)))

target-pv2000-clean:
	$(RM) -fr target/pv2000/obj
