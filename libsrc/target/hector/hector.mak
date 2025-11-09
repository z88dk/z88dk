# +hector builds heavily on +zx
HECTOR_GLOBS := \
	"target/hector/games/*.asm" \
	"target/hector/graphics/*.asm" \
	"target/hector/hector/*.asm" \
	"target/hector/input/*.asm" \
	"target/hector/stdio/*.asm" 

HECTOR_GLOBS_ex := \
	target/hector/games/*.asm \
	target/hector/graphics/*.asm \
	target/hector/hector/*.asm \
	target/hector/input/*.asm \
	target/hector/stdio/*.asm 


HECTOR_TARGETS := target/hector/obj/target-hector-hector1 target/hector/obj/target-hector-hectorhr
		

CLEAN += target-hector-clean

target-hector: $(HECTOR_TARGETS)

.PHONY: target-hector target-hector-clean


$(eval $(call buildtargetasm,target/hector,z80,hector1,-mz80,$(HECTOR_GLOBS),$(HECTOR_GLOBS_ex)))
$(eval $(call buildtargetasm,target/hector,z80,hectorhr,-mz80,$(HECTOR_GLOBS),$(HECTOR_GLOBS_ex)))

target-hector-clean:
	$(RM) -fr target/hector/obj
