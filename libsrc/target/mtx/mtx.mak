

MTX_GLOBS := \
	"target/mtx/games/*.asm" \
	"target/mtx/stdio/*.asm" \
	"target/mtx/time/*.asm"

MTX_GLOBS_ex := \
	target/mtx/games/*.asm \
	target/mtx/stdio/*.asm \
	target/mtx/time/*.asm


MTX_CFILES = $(wildcard target/mtx/rs232/*.c) 

MTX_OFILES = $(patsubst target/mtx/%,target/mtx/obj/mtx/%,$(MTX_CFILES:.c=.o))


MTX_TARGETS := target/mtx/obj/target-mtx-mtx  $(MTX_OFILES) classic/video/tms9918/obj/mtx classic/games/obj/.stamp-mtx classic/gfx/obj/.stamp-mtx
		

CLEAN += target-mtx-clean

$(eval $(call gfx_stamp_args,mtx,TARGET=mtx))

target-mtx: $(MTX_TARGETS)

.PHONY: target-mtx target-mtx-clean

$(eval $(call buildtms9918,mtx,mtx))


$(eval $(call buildtargetasm,target/mtx,z80,mtx,-mz80,$(MTX_GLOBS),$(MTX_GLOBS_ex)))
$(eval $(call buildtargetc,target/mtx,mtx))


target-mtx-clean:
	$(RM) -fr target/mtx/obj
