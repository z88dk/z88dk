SOS_GLOBS := \
	"target/sos/sos/*.asm"  \
	"target/sos/stdio/*.asm"  

SOS_GLOBS_ex := \
	target/sos/sos/*.asm  \
	target/sos/stdio/*.asm  


SOS_CFILES = $(wildcard target/sos/tape/*.c) 

SOS_OFILES = $(addprefix target/sos/obj/sos/, $(SOS_CFILES:.c=.o)) 



SOS_TARGETS := target/sos/obj/target-sos-sos \
	$(SOS_OFILES)
		

CLEAN += target-sos-clean

target-sos: $(SOS_TARGETS)

.PHONY: target-sos target-sos-clean

$(eval $(call buildtargetasm,target/sos,z80,sos,-mz80,$(SOS_GLOBS),$(SOS_GLOBS_ex)))
$(eval $(call buildtargetc,target/sos,sos))

target-sos-clean:
	$(RM) -fr target/sos/obj
