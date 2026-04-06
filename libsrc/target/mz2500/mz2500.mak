MZ2500_GLOBS := \
	"target/mz2500/stdio/*.asm"  

MZ2500_GLOBS_ex := \
	target/mz2500/stdio/*.asm 


MZ2500_CFILES = $(wildcard target/mz2500/tape/*.c) 

MZ2500_OFILES = $(addprefix target/mz2500/obj/mz2500/, $(MZ2500_CFILES:.c=.o)) 



MZ2500_TARGETS := target/mz2500/obj/target-mz2500-mz2500 \
	$(MZ2500_OFILES)
		

CLEAN += target-mz2500-clean

target-mz2500: $(MZ2500_TARGETS)

.PHONY: target-mz2500 target-mz2500-clean

$(eval $(call buildtargetasm,target/mz2500,z80,mz2500,-mz80,$(MZ2500_GLOBS),$(MZ2500_GLOBS_ex)))
$(eval $(call buildtargetc,target/mz2500,mz2500))

target-mz2500-clean:
	$(RM) -fr target/mz2500/obj
