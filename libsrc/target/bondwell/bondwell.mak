BONDWELL_GLOBS := \
	"target/bondwell/graphics/*.asm" \
	"target/bondwell/stdio/*.asm" 

BONDWELL_GLOBS_ex := \
	target/bondwell/graphics/*.asm \
	target/bondwell/stdio/*.asm 


BONDWELL_TARGETS := target/bondwell/obj/target-bondwell-bondwell classic/games/obj/.stamp-cpm-bondwell classic/gfx/obj/.stamp-cpm-bondwell
		

CLEAN += target-bondwell-clean
bondwell.lib: cpm_clib.lib $(BONDWELL_TARGETS)
	@echo ''
	@echo '--- Building Bondwell 12/14 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6845 TARGET=bondwell
	TARGET=bondwell TYPE=z80 $(LIBLINKER) -DFORbondwell -x$(OUTPUT_DIRECTORY)/bondwell @$(TARGET_DIRECTORY)/bondwell/bw.lst

TOCREATE += $(call check_target,bondwell,bondwell.lib $(CPMLIBS))

target-bondwell: $(BONDWELL_TARGETS)

.PHONY: target-bondwell target-bondwell-clean


$(eval $(call buildtargetasm,target/bondwell,z80,bondwell,-mz80,$(BONDWELL_GLOBS),$(BONDWELL_GLOBS_ex)))

target-bondwell-clean:
	$(RM) -fr target/bondwell/obj
