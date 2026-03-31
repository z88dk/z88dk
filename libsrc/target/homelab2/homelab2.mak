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


HOMELAB2_TARGETS := target/homelab2/obj/target-homelab2-homelab2
		

CLEAN += target-homelab2-clean

target-homelab2: $(HOMELAB2_TARGETS)

.PHONY: target-homelab2 target-homelab2-clean


$(eval $(call buildtargetasm,target/homelab2,z80,homelab2,-mz80,$(HOMELAB2_GLOBS),$(HOMELAB2_GLOBS_ex)))

target-homelab2-clean:
	$(RM) -fr target/homelab2/obj
