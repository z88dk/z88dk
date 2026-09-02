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

TVC_OFILES = $(patsubst target/tvc/%,target/tvc/obj/tvc/%,$(TVC_CFILES:.c=.o))


# romgfx is a library of its own (tvc_romgfx.lib) so it gets its own object
# tree, keeping the two libraries' contents apart
TVCROMGFX_GLOBS := "target/tvc/romgfx/*.asm"

TVCROMGFX_GLOBS_ex := target/tvc/romgfx/*.asm

TVCROMGFX_CFILES = $(wildcard target/tvc/romgfx/*.c)

TVCROMGFX_OFILES = $(patsubst target/tvc/romgfx/%,target/tvc/romgfx/obj/tvc/%,$(TVCROMGFX_CFILES:.c=.o))


TVC_TARGETS := target/tvc/obj/target-tvc-tvc \
	$(TVC_OFILES) \
	classic/games/obj/.stamp-tvc classic/gfx/obj/.stamp-tvc

TVCROMGFX_TARGETS := target/tvc/romgfx/obj/target-tvc-romgfx-tvc \
	$(TVCROMGFX_OFILES)

tvc_clib.lib: $(TARGET_CLIB_DEPS) $(TVC_TARGETS)
	TARGET=tvc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORtvc -x$(OUTPUT_DIRECTORY)/tvc_clib @$(TARGET_DIRECTORY)/tvc/tvc.lst

tvc_romgfx.lib: tvc_clib.lib $(TVCROMGFX_TARGETS)
	TARGET=tvc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORtvc -x$(OUTPUT_DIRECTORY)/tvc_romgfx @$(TARGET_DIRECTORY)/tvc/tvc_romgfx.lst


CLEAN += target-tvc-clean
TOCREATE += $(call check_target,tvc,tvc_clib.lib tvc_romgfx.lib)

$(eval $(call gfx_stamp_args,tvc,TARGET=tvc))

target-tvc: $(TVC_TARGETS) $(TVCROMGFX_TARGETS)

.PHONY: target-tvc target-tvc-clean

$(eval $(call buildtargetasm,target/tvc,z80,tvc,-mz80,$(TVC_GLOBS),$(TVC_GLOBS_ex)))
$(eval $(call buildtargetasm,target/tvc/romgfx,z80,tvc,-mz80,$(TVCROMGFX_GLOBS),$(TVCROMGFX_GLOBS_ex)))
$(eval $(call buildtargetc,target/tvc,tvc,-DTVC -D__TVC__ $(CFLAGS)))
$(eval $(call buildtargetc,target/tvc/romgfx,tvc,-DTVC -D__TVC__ $(CFLAGS)))

target-tvc-clean:
	$(RM) -fr target/tvc/obj target/tvc/romgfx/obj
