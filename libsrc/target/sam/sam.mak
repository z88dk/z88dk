SAM_GLOBS := \
	"target/sam/dac/*.asm" \
	"target/sam/far/*.asm" \
	"target/sam/games/*.asm" \
	"target/sam/graphics/*.asm" \
	"target/sam/input/*.asm" \
	"target/sam/interrupt/*.asm" \
	"target/sam/psg/*.asm" \
	"target/sam/sam/*.asm" \
	"target/sam/stdio/*.asm" \
	"target/sam/time/*.asm" \
	"target/sam/*.asm" \
	"target/zx/classic/graphics/rowtab.asm" \
	"target/zx/classic/graphics/res_MODE0.asm" \
	"target/zx/classic/graphics/pointxy_MODE0.asm" \
	"target/zx/classic/graphics/xor_MODE0.asm" \
	"target/zx/classic/graphics/plot_MODE0.asm" \
	"target/zx/classic/graphics/pixladdr_MODE0.asm" \
	"target/zx/classic/graphics/__set_zx_pixel_colour.asm" \
	"target/zx/classic/games/bit*.asm" \
	"target/zx/classic/input/in_JoySinclair*.asm" \
	"target/zx/classic/stdio/*.asm" \
	"target/shared/clock.asm" 

SAM_GLOBS_ex := \
	target/sam/dac/*.asm \
	target/sam/far/*.asm \
	target/sam/games/*.asm \
	target/sam/graphics/*.asm \
	target/sam/input/*.asm \
	target/sam/interrupt/*.asm \
	target/sam/psg/*.asm \
	target/sam/sam/*.asm \
	target/sam/stdio/*.asm \
	target/sam/time/*.asm \
	target/sam/*.asm \
	target/zx/classic/graphics/rowtab.asm \
	target/zx/classic/graphics/res_MODE0.asm \
	target/zx/classic/graphics/pointxy_MODE0.asm \
	target/zx/classic/graphics/xor_MODE0.asm \
	target/zx/classic/graphics/plot_MODE0.asm \
	target/zx/classic/graphics/pixladdr_MODE0.asm \
	target/zx/classic/graphics/__set_zx_pixel_colour.asm \
	target/zx/classic/games/bit*.asm  \
	target/zx/classic/input/in_JoySinclair*.asm \
	target/zx/classic/stdio/*.asm \
	target/shared/clock.asm

SAM_CPM_GLOBS := \
	"target/sam/dac/*.asm" \
	"target/sam/far/*.asm" \
	"target/sam/games/*.asm" \
	"target/sam/input/*.asm" \
	"target/sam/interrupt/*.asm" \
	"target/sam/psg/*.asm" \
	"target/sam/sam/*.asm" \
	"target/sam/time/*.asm" \
	"target/sam/*.asm" \
	"target/zx/classic/games/bit*.asm"
	

SAM_CPM_GLOBS_ex := \
	target/sam/dac/*.asm \
	target/sam/far/*.asm \
	target/sam/games/*.asm \
	target/sam/input/*.asm \
	target/sam/interrupt/*.asm \
	target/sam/psg/*.asm \
	target/sam/sam/*.asm \
	target/sam/time/*.asm \
	target/sam/*.asm \
	target/zx/classic/games/bit*.asm  
	

SAM_CFILES = 

SAM_OFILES = $(addprefix target/sam/obj/sam/, $(SAM_CFILES:.c=.o))


SAM_TARGETS := target/sam/obj/target-sam-sam target/sam/obj/target-sam-samcpm \
	$(SAM_OFILES)
		

CLEAN += target-sam-clean

target-sam: $(SAM_TARGETS)

.PHONY: target-sam target-sam-clean

$(eval $(call buildtargetasm,target/sam,z80,sam,-mz80,$(SAM_GLOBS),$(SAM_GLOBS_ex)))
$(eval $(call buildtargetasm,target/sam,z80,samcpm,-mz80,$(SAM_CPM_GLOBS),$(SAM_CPM_GLOBS_ex)))
$(eval $(call buildtargetc,target/sam,sam))

target-sam-clean:
	$(RM) -fr target/sam/obj
