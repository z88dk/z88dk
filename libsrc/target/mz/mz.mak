MZ_GLOBS := \
	"target/mz/*.asm"  \
	"target/mz/graphics/*.asm" \
	"target/mz/stdio/*.asm" \
	"target/mz/stdio/ansi/*.asm" \
	"target/mz/tape/*.asm"  

MZ_GLOBS_ex := \
	target/mz/*.asm  \
	target/mz/graphics/*.asm \
	target/mz/stdio/*.asm \
	target/mz/stdio/ansi/*.asm \
	target/mz/tape/*.asm  


MZ_CFILES = $(wildcard target/mz/tape/*.c) 

MZ_OFILES = $(addprefix target/mz/obj/mz/, $(MZ_CFILES:.c=.o)) 



MZ_TARGETS := target/mz/obj/target-mz-mz \
	$(MZ_OFILES)
		

CLEAN += target-mz-clean

target-mz: $(MZ_TARGETS)

.PHONY: target-mz target-mz-clean

$(eval $(call buildtargetasm,target/mz,z80,mz,-mz80,$(MZ_GLOBS),$(MZ_GLOBS_ex)))
$(eval $(call buildtargetc,target/mz,mz))

target-mz-clean:
	$(RM) -fr target/mz/obj
