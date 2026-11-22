HOMELAB_GLOBS := \
	"target/homelab/games/*.asm" \
	"target/homelab/graphics/*.asm" \
	"target/homelab/input/*.asm" \
	"target/homelab/stdio/*.asm" 

HOMELAB_GLOBS_ex := \
	target/homelab/games/*.asm \
	target/homelab/graphics/*.asm \
	target/homelab/input/*.asm \
	target/homelab/stdio/*.asm 


HOMELAB_TARGETS := target/homelab/obj/target-homelab-homelab classic/games/obj/.stamp-homelab classic/gfx/obj/.stamp-homelab
		

CLEAN += target-homelab-clean
TOCREATE += $(call check_target,homelab,homelab_clib.lib)
$(eval $(call gfx_stamp_args,homelab,TARGET=homelab FLAVOUR="gencon narrow"))
$(eval $(call buildtargetasm,target/homelab,z80,homelab,-mz80,$(HOMELAB_GLOBS),$(HOMELAB_GLOBS_ex)))

homelab_clib.lib: $(TARGET_CLIB_DEPS) $(HOMELAB_TARGETS)
	@echo ''
	@echo '--- Building Homelab Library ---'
	@echo ''
	TARGET=homelab TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhomelab -x$(OUTPUT_DIRECTORY)/homelab_clib @$(TARGET_DIRECTORY)/homelab/homelab.lst



target-homelab: $(HOMELAB_TARGETS)

.PHONY: target-homelab target-homelab-clean



target-homelab-clean:
	$(RM) -fr target/homelab/obj
