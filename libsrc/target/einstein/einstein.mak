EINSTEIN_GLOBS := \
	"target/einstein/psg/*.asm" \
	"target/einstein/stdio/*.asm" 

EINSTEIN_GLOBS_ex := \
	target/einstein/psg/*.asm \
	target/einstein/stdio/*.asm 


EINSTEIN_TARGETS := target/einstein/obj/target-einstein-einstein classic/video/tms9918/obj/einstein classic/video/mc6845/obj/einstein classic/games/obj/.stamp-cpm-einstein classic/gfx/obj/.stamp-cpm-einstein
EINSTEIN256_TARGETS := classic/video/tms9918/obj/einstein256
		

CLEAN += target-einstein-clean
TOCREATE += $(call check_target,einstein,einstein.lib einstein256.lib $(CPMLIBS))

$(eval $(call buildtargetasm,target/einstein,z80,einstein,-mz80,$(EINSTEIN_GLOBS),$(EINSTEIN_GLOBS_ex)))
$(eval $(call buildvideo,tms9918,TMS9918,cpm,einstein))
$(eval $(call buildvideo,tms9918,TMS9918,cpm,einstein256))
$(eval $(call buildvideo,mc6845,MC6845,einstein,))

einstein.lib: cpm_clib.lib $(EINSTEIN_TARGETS)
	TARGET=einstein TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFOReinstein -x$(OUTPUT_DIRECTORY)/einstein @$(TARGET_DIRECTORY)/einstein/einstein.lst

einstein256.lib: cpm_clib.lib $(EINSTEIN_TARGETS) $(EINSTEIN256_TARGETS)
	TARGET=einstein256 TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFOReinstein256 -x$(OUTPUT_DIRECTORY)/einstein256 @$(TARGET_DIRECTORY)/einstein/einstein256.lst

target-einstein: $(EINSTEIN_TARGETS)

.PHONY: target-einstein target-einstein-clean



target-einstein-clean:
	$(RM) -fr target/einstein/obj
