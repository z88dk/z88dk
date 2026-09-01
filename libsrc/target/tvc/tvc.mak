TVC_GLOBS := \
	"target/tvc/*.asm" \
	"target/tvc/stdio/*.asm" \
	"target/tvc/games/*.asm" \
	"target/tvc/time/*.asm" \
	"target/tvc/sound/*.asm"

TVC_GLOBS_ex := \
	target/tvc/*.asm \
	target/tvc/stdio/*.asm \
	target/tvc/games/*.asm \
	target/tvc/time/*.asm \
	target/tvc/sound/*.asm

TVC_CFILES = $(wildcard target/tvc/*.c) $(wildcard target/tvc/sound/*.c)

TVC_OFILES = $(addprefix target/tvc/obj/tvc/, $(TVC_CFILES:.c=.o))


# romgfx is a library of its own (tvc_romgfx.lib) so it gets its own object
# tree, keeping the two libraries' contents apart
TVCROMGFX_GLOBS := "target/tvc/romgfx/*.asm"

TVCROMGFX_GLOBS_ex := target/tvc/romgfx/*.asm

TVCROMGFX_CFILES = $(wildcard target/tvc/romgfx/*.c)

TVCROMGFX_OFILES = $(addprefix target/tvc/romgfx/obj/tvc/, $(TVCROMGFX_CFILES:.c=.o))


TVC_TARGETS := target/tvc/obj/target-tvc-tvc \
	$(TVC_OFILES) \
	classic/games/obj/.stamp-tvc classic/gfx/obj/.stamp-tvc

TVCROMGFX_TARGETS := target/tvc/romgfx/obj/target-tvc-romgfx-tvc \
	$(TVCROMGFX_OFILES)


CLEAN += target-tvc-clean

target-tvc: $(TVC_TARGETS) $(TVCROMGFX_TARGETS)

.PHONY: target-tvc target-tvc-clean

$(eval $(call buildtargetasm,target/tvc,z80,tvc,-mz80,$(TVC_GLOBS),$(TVC_GLOBS_ex)))
$(eval $(call buildtargetasm,target/tvc/romgfx,z80,tvc,-mz80,$(TVCROMGFX_GLOBS),$(TVCROMGFX_GLOBS_ex)))
$(eval $(call buildtargetc,target/tvc,tvc,-DTVC -D__TVC__ $(CFLAGS)))
$(eval $(call buildtargetc,target/tvc/romgfx,tvc,-DTVC -D__TVC__ $(CFLAGS)))

target-tvc-clean:
	$(RM) -fr target/tvc/obj target/tvc/romgfx/obj
