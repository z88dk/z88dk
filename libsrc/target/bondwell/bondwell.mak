BONDWELL_GLOBS := \
	"target/bondwell/graphics/*.asm" \
	"target/bondwell/stdio/*.asm" 

BONDWELL_GLOBS_ex := \
	target/bondwell/graphics/*.asm \
	target/bondwell/stdio/*.asm 


BONDWELL_TARGETS := target/bondwell/obj/target-bondwell-bondwell classic/video/mc6845/obj/bondwell classic/games/obj/.stamp-cpm-bondwell classic/gfx/obj/.stamp-cpm-bondwell
		

CLEAN += target-bondwell-clean
TOCREATE += $(call check_target,bondwell,bondwell.lib $(CPMLIBS))
$(eval $(call buildtargetasm,target/bondwell,z80,bondwell,-mz80,$(BONDWELL_GLOBS),$(BONDWELL_GLOBS_ex)))
$(eval $(call buildvideo,mc6845,MC6845,bondwell,))

bondwell.lib: cpm_clib.lib $(BONDWELL_TARGETS)
	@echo ''
	@echo '--- Building Bondwell 12/14 Library ---'
	@echo ''
	TARGET=bondwell TYPE=z80 $(LIBLINKER) -DFORbondwell -x$(OUTPUT_DIRECTORY)/bondwell @$(TARGET_DIRECTORY)/bondwell/bw.lst


target-bondwell: $(BONDWELL_TARGETS)

.PHONY: target-bondwell target-bondwell-clean



target-bondwell-clean:
	$(RM) -fr target/bondwell/obj
