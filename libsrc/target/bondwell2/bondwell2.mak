BONDWELL2_GLOBS := \
	"target/bondwell2/graphics/*.asm" \
	"target/bondwell2/stdio/*.asm" 

BONDWELL2_GLOBS_ex := \
	target/bondwell2/graphics/*.asm \
	target/bondwell2/stdio/*.asm 


BONDWELL2_TARGETS := target/bondwell2/obj/target-bondwell2-bondwell2 classic/games/obj/.stamp-cpm-bondwell2 classic/gfx/obj/.stamp-cpm-bondwell2
		

CLEAN += target-bondwell2-clean
TOCREATE += $(call check_target,bondwell2,bondwell2.lib $(CPMLIBS))
$(eval $(call buildtargetasm,target/bondwell2,z80,bondwell2,-mz80 -IXIY,$(BONDWELL2_GLOBS),$(BONDWELL2_GLOBS_ex)))

bondwell2.lib: cpm_clib.lib $(BONDWELL2_TARGETS)
	@echo ''
	@echo '--- Building Bondwell 2 Library ---'
	@echo ''
	$(MAKE) -C classic/video/msm6255 TARGET=cpm SUBTYPE=bondwell2
	TARGET=bondwell2 TYPE=ixiy $(LIBLINKER) -IXIY -DFORbondwell2 -x$(OUTPUT_DIRECTORY)/bondwell2 @$(TARGET_DIRECTORY)/bondwell2/bw2.lst


target-bondwell2: $(BONDWELL2_TARGETS)

.PHONY: target-bondwell2 target-bondwell2-clean



target-bondwell2-clean:
	$(RM) -fr target/bondwell2/obj
