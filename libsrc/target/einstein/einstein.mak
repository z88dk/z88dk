EINSTEIN_GLOBS := \
	"target/einstein/psg/*.asm" \
	"target/einstein/stdio/*.asm" 

EINSTEIN_GLOBS_ex := \
	target/einstein/psg/*.asm \
	target/einstein/stdio/*.asm 


EINSTEIN_TARGETS := target/einstein/obj/target-einstein-einstein classic/games/obj/.stamp-cpm-einstein classic/gfx/obj/.stamp-cpm-einstein
		

CLEAN += target-einstein-clean
TOCREATE += $(call check_target,einstein,einstein.lib einstein256.lib $(CPMLIBS))

einstein.lib: cpm_clib.lib $(EINSTEIN_TARGETS)
	$(MAKE) -C classic/video/tms9918 TARGET=cpm SUBTYPE=einstein
	$(MAKE) -C classic/video/mc6845 TARGET=einstein
	TARGET=einstein TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFOReinstein -x$(OUTPUT_DIRECTORY)/einstein @$(TARGET_DIRECTORY)/einstein/einstein.lst

einstein256.lib: cpm_clib.lib $(EINSTEIN_TARGETS)
	$(MAKE) -C classic/video/tms9918 TARGET=cpm SUBTYPE=einstein256
	TARGET=einstein256 TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFOReinstein256 -x$(OUTPUT_DIRECTORY)/einstein256 @$(TARGET_DIRECTORY)/einstein/einstein256.lst

target-einstein: $(EINSTEIN_TARGETS)

.PHONY: target-einstein target-einstein-clean


$(eval $(call buildtargetasm,target/einstein,z80,einstein,-mz80,$(EINSTEIN_GLOBS),$(EINSTEIN_GLOBS_ex)))

target-einstein-clean:
	$(RM) -fr target/einstein/obj
