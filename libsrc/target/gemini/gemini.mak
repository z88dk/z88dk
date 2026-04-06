GEMINI_GLOBS := \
	"target/gemini/graphics/*.asm" \
	"target/gemini/stdio/*.asm" \
	"target/gemini/stdio/ansi/*.asm" 

GEMINI_GLOBS_ex := \
	target/gemini/graphics/*.asm \
	target/gemini/stdio/*.asm  \
	target/gemini/stdio/ansi/*.asm 


GEMINI_TARGETS := target/gemini/obj/target-gemini-gemini
		

CLEAN += target-gemini-clean

target-gemini: $(GEMINI_TARGETS)

.PHONY: target-gemini target-gemini-clean


$(eval $(call buildtargetasm,target/gemini,z80,gemini,-mz80,$(GEMINI_GLOBS),$(GEMINI_GLOBS_ex)))

target-gemini-clean:
	$(RM) -fr target/gemini/obj
