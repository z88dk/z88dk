SAM_GLOBS := \
	"$(Z88DK_LIBSRC)/target/sam/dac/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/far/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/games/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/graphics/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/input/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/interrupt/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/psg/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/sam/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/stdio/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/time/*.asm" \
	"$(Z88DK_LIBSRC)/target/sam/*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/graphics/rowtab.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/graphics/res_MODE0.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/graphics/pointxy_MODE0.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/graphics/xor_MODE0.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/graphics/plot_MODE0.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/graphics/pixladdr_MODE0.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/games/bit*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/input/in_JoySinclair*.asm" \
	"$(Z88DK_LIBSRC)/target/zx/classic/stdio/*.asm" 

SAM_GLOBS_ex := \
	$(Z88DK_LIBSRC)/target/sam/dac/*.asm \
	$(Z88DK_LIBSRC)/target/sam/far/*.asm \
	$(Z88DK_LIBSRC)/target/sam/games/*.asm \
	$(Z88DK_LIBSRC)/target/sam/graphics/*.asm \
	$(Z88DK_LIBSRC)/target/sam/input/*.asm \
	$(Z88DK_LIBSRC)/target/sam/interrupt/*.asm \
	$(Z88DK_LIBSRC)/target/sam/psg/*.asm \
	$(Z88DK_LIBSRC)/target/sam/sam/*.asm \
	$(Z88DK_LIBSRC)/target/sam/stdio/*.asm \
	$(Z88DK_LIBSRC)/target/sam/time/*.asm \
	$(Z88DK_LIBSRC)/target/sam/*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/graphics/rowtab.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/graphics/res_MODE0.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/graphics/pointxy_MODE0.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/graphics/xor_MODE0.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/graphics/plot_MODE0.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/graphics/pixladdr_MODE0.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/games/bit*.asm  \
	$(Z88DK_LIBSRC)/target/zx/classic/input/in_JoySinclair*.asm \
	$(Z88DK_LIBSRC)/target/zx/classic/stdio/*.asm

SAM_CFILES = 

SAM_OFILES = $(addprefix target/sam/obj/sam/, $(SAM_CFILES:.c=.o))


SAM_TARGETS := target/sam/obj/target-sam-sam \
	$(SAM_OFILES)
		

CLEAN += target-sam-clean

target-sam: $(SAM_TARGETS)

.PHONY: target-sam target-sam-clean

$(eval $(call buildtargetasm,target/sam,z80,sam,-mz80,$(SAM_GLOBS),$(SAM_GLOBS_ex)))
$(eval $(call buildtargetc,target/sam,sam))

target-sam-clean:
	$(RM) -fr target/sam/obj
