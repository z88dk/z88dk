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


HOMELAB_TARGETS := target/homelab/obj/target-homelab-homelab
		

CLEAN += target-homelab-clean

target-homelab: $(HOMELAB_TARGETS)

.PHONY: target-homelab target-homelab-clean


$(eval $(call buildtargetasm,target/homelab,z80,homelab,-mz80,$(HOMELAB_GLOBS),$(HOMELAB_GLOBS_ex)))

target-homelab-clean:
	$(RM) -fr target/homelab/obj
