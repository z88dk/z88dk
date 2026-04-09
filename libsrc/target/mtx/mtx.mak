

MTX_GLOBS := \
	"target/mtx/games/*.asm" \
	"target/mtx/stdio/*.asm" \
	"target/mtx/time/*.asm"

MTX_GLOBS_ex := \
	target/mtx/games/*.asm \
	target/mtx/stdio/*.asm \
	target/mtx/time/*.asm


MTX_CFILES = $(wildcard target/mtx/rs232/*.c) 

MTX_OFILES = $(addprefix target/mtx/obj/mtx/, $(MTX_CFILES:.c=.o)) 


MTX_TARGETS := target/mtx/obj/target-mtx-mtx  $(MTX_OFILES) 
		

CLEAN += target-mtx-clean

target-mtx: $(MTX_TARGETS)

.PHONY: target-mtx target-mtx-clean


$(eval $(call buildtargetasm,target/mtx,z80,mtx,-mz80,$(MTX_GLOBS),$(MTX_GLOBS_ex)))
$(eval $(call buildtargetc,target/mtx,mtx))


target-mtx-clean:
	$(RM) -fr target/mtx/obj
