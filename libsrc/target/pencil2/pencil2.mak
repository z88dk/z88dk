PENCIL2_GLOBS := \
	"target/pencil2/games/*.asm" \
	"target/pencil2/input/*.asm" \
	"target/pencil2/stdio/*.asm" 

PENCIL2_GLOBS_ex := \
	target/pencil2/games/*.asm \
	target/pencil2/input/*.asm \
	target/pencil2/stdio/*.asm 


PENCIL2_TARGETS := target/pencil2/obj/target-pencil2-pencil2
		

CLEAN += target-pencil2-clean

target-pencil2: $(PENCIL2_TARGETS)

.PHONY: target-pencil2 target-pencil2-clean


$(eval $(call buildtargetasm,target/pencil2,z80,pencil2,-mz80,$(PENCIL2_GLOBS),$(PENCIL2_GLOBS_ex)))

target-pencil2-clean:
	$(RM) -fr target/pencil2/obj
