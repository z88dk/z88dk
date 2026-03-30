PRIMO_GLOBS := \
	"target/primo/games/*.asm" \
	"target/primo/graphics/*.asm" \
	"target/primo/input/*.asm" \
	"target/primo/stdio/*.asm" 

PRIMO_GLOBS_ex := \
	target/primo/games/*.asm \
	target/primo/graphics/*.asm \
	target/primo/input/*.asm \
	target/primo/stdio/*.asm 


PRIMO_TARGETS := target/primo/obj/target-primo-primo
		

CLEAN += target-primo-clean

target-primo: $(PRIMO_TARGETS)

.PHONY: target-primo target-primo-clean


$(eval $(call buildtargetasm,target/primo,z80,primo,-mz80 -IXIY,$(PRIMO_GLOBS),$(PRIMO_GLOBS_ex)))

target-primo-clean:
	$(RM) -fr target/primo/obj
