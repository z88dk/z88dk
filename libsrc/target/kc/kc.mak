KC_GLOBS := \
	"target/kc/graphics/*.asm" \
	"target/kc/stdio/*.asm" 

KC_GLOBS_ex := \
	target/kc/graphics/*.asm \
	target/kc/stdio/*.asm 


KC_TARGETS := target/kc/obj/target-kc-kc
		

CLEAN += target-kc-clean

target-kc: $(KC_TARGETS)

.PHONY: target-kc target-kc-clean


$(eval $(call buildtargetasm,target/kc,ixiy,kc,-mz80 -IXIY,$(KC_GLOBS),$(KC_GLOBS_ex)))

target-kc-clean:
	$(RM) -fr target/kc/obj
