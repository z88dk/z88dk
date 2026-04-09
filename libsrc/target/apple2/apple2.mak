APPLE2_GLOBS := \
	"target/apple2/*.asm" \
	"target/apple2/stdio/*.asm" 

APPLE2_GLOBS_ex := \
	target/apple2/*.asm \
	target/apple2/stdio/*.asm 


APPLE2_TARGETS := target/apple2/obj/target-apple2-apple2
		

CLEAN += target-apple2-clean

target-apple2: $(APPLE2_TARGETS)

.PHONY: target-apple2 target-apple2-clean


$(eval $(call buildtargetasm,target/apple2,z80,apple2,-mz80,$(APPLE2_GLOBS),$(APPLE2_GLOBS_ex)))

target-apple2-clean:
	$(RM) -fr target/apple2/obj
