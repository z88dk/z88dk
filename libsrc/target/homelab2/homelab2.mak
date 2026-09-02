HOMELAB2_GLOBS := \
	"target/homelab2/games/*.asm" \
	"target/homelab2/graphics/*.asm" \
	"target/homelab2/input/*.asm" \
	"target/homelab2/stdio/*.asm" 

HOMELAB2_GLOBS_ex := \
	target/homelab2/games/*.asm \
	target/homelab2/graphics/*.asm \
	target/homelab2/input/*.asm \
	target/homelab2/stdio/*.asm 


HOMELAB2_TARGETS := target/homelab2/obj/target-homelab2-homelab2 classic/games/obj/.stamp-homelab2 classic/gfx/obj/.stamp-homelab2
		

CLEAN += target-homelab2-clean
homelab2_clib.lib: $(TARGET_CLIB_DEPS) $(HOMELAB2_TARGETS)
	@echo ''
	@echo '--- Building Homelab2 Library ---'
	@echo ''
	TARGET=homelab2 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhomelab2 -x$(OUTPUT_DIRECTORY)/homelab2_clib @$(TARGET_DIRECTORY)/homelab2/homelab2.lst

TOCREATE += $(call check_target,homelab2,homelab2_clib.lib)

$(eval $(call gfx_stamp_args,homelab2,TARGET=homelab2 FLAVOUR="gencon narrow"))

target-homelab2: $(HOMELAB2_TARGETS)

.PHONY: target-homelab2 target-homelab2-clean


$(eval $(call buildtargetasm,target/homelab2,z80,homelab2,-mz80,$(HOMELAB2_GLOBS),$(HOMELAB2_GLOBS_ex)))

target-homelab2-clean:
	$(RM) -fr target/homelab2/obj
