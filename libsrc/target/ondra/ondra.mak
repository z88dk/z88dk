ONDRA_GLOBS := \
	"target/ondra/games/*.asm" \
	"target/ondra/graphics/*.asm" \
	"target/ondra/input/*.asm" \
	"target/ondra/stdio/*.asm" 

ONDRA_GLOBS_ex := \
	target/ondra/games/*.asm \
	target/ondra/graphics/*.asm \
	target/ondra/input/*.asm \
	target/ondra/stdio/*.asm 


ONDRA_TARGETS := target/ondra/obj/target-ondra-ondra
		

CLEAN += target-ondra-clean

target-ondra: $(ONDRA_TARGETS)

.PHONY: target-ondra target-ondra-clean


$(eval $(call buildtargetasm,target/ondra,z80,ondra,-mz80,$(ONDRA_GLOBS),$(ONDRA_GLOBS_ex)))

target-ondra-clean:
	$(RM) -fr target/ondra/obj
