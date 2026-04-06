SRR_GLOBS := \
	"target/srr/games/*.asm"  \
	"target/srr/graphics/*.asm"  \
	"target/srr/input/*.asm"  \
	"target/srr/srr/*.asm"  \
	"target/srr/stdio/*.asm"  

SRR_GLOBS_ex := \
	target/srr/games/*.asm  \
	target/srr/graphics/*.asm  \
	target/srr/input/*.asm  \
	target/srr/srr/*.asm  \
	target/srr/stdio/*.asm  


SRR_CFILES = $(wildcard target/srr/srr/*.c) 

SRR_OFILES = $(addprefix target/srr/obj/srr/, $(SRR_CFILES:.c=.o)) 



SRR_TARGETS := target/srr/obj/target-srr-srr \
	$(SRR_OFILES)
		

CLEAN += target-srr-clean

target-srr: $(SRR_TARGETS)

.PHONY: target-srr target-srr-clean

$(eval $(call buildtargetasm,target/srr,z80,srr,-mz80,$(SRR_GLOBS),$(SRR_GLOBS_ex)))
$(eval $(call buildtargetc,target/srr,srr))

target-srr-clean:
	$(RM) -fr target/srr/obj
