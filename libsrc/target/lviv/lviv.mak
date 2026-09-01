LVIV_GLOBS := \
	"target/lviv/games/*.asm" \
	"target/lviv/graphics/*.asm" \
	"target/lviv/input/*.asm" \
	"target/lviv/stdio/*.asm" 

LVIV_GLOBS_ex := \
	target/lviv/games/*.asm \
	target/lviv/graphics/*.asm \
	target/lviv/input/*.asm \
	target/lviv/stdio/*.asm 


LVIV_TARGETS := target/lviv/obj/target-lviv-lviv classic/games/obj/.stamp-lviv classic/gfx/obj/.stamp-lviv
		

CLEAN += target-lviv-clean

$(eval $(call gfx_stamp_args,lviv,TARGET=lviv FLAVOUR="narrow portable"))

target-lviv: $(LVIV_TARGETS)

.PHONY: target-lviv target-lviv-clean


$(eval $(call buildtargetasm,target/lviv,8080,lviv,-m8080,$(LVIV_GLOBS),$(LVIV_GLOBS_ex)))

target-lviv-clean:
	$(RM) -fr target/lviv/obj
