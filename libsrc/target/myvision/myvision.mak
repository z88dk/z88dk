MYVISION_GLOBS := \
	"target/myvision/games/*.asm" \
	"target/myvision/input/*.asm" \
	"target/myvision/psg/*.asm" 

MYVISION_GLOBS_ex := \
	target/myvision/games/*.asm \
	target/myvision/input/*.asm \
	target/myvision/psg/*.asm 


MYVISION_TARGETS := target/myvision/obj/target-myvision-myvision classic/games/obj/.stamp-myvision classic/gfx/obj/.stamp-myvision
		

CLEAN += target-myvision-clean

$(eval $(call gfx_stamp_args,myvision,TARGET=myvision))

target-myvision: $(MYVISION_TARGETS)

.PHONY: target-myvision target-myvision-clean


$(eval $(call buildtargetasm,target/myvision,z80,myvision,-mz80,$(MYVISION_GLOBS),$(MYVISION_GLOBS_ex)))

target-myvision-clean:
	$(RM) -fr target/myvision/obj
