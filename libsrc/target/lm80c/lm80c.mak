LM80C_GLOBS := \
	"target/lm80c/psg/*.asm" \
	"target/lm80c/stdio/*.asm" 

LM80C_GLOBS_ex := \
	target/lm80c/psg/*.asm \
	target/lm80c/stdio/*.asm 

LM80C_CFILES = $(wildcard target/lm80c/rs232/*.c)
LM80C_OFILES = $(addprefix target/lm80c/obj/lm80c/, $(LM80C_CFILES:.c=.o))

LM80C_TARGETS := target/lm80c/obj/target-lm80c-lm80c $(LM80C_OFILES)
		

CLEAN += target-lm80c-clean

target-lm80c: $(LM80C_TARGETS)

.PHONY: target-lm80c target-lm80c-clean


$(eval $(call buildtargetasm,target/lm80c,z80,lm80c,-mz80,$(LM80C_GLOBS),$(LM80C_GLOBS_ex)))
$(eval $(call buildtargetc,target/lm80c,lm80c))

target-lm80c-clean:
	$(RM) -fr target/lm80c/obj
