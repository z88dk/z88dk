SOL20_GLOBS := \
	"target/sol20/games/*.asm" \
	"target/sol20/stdio/*.asm" 

SOL20_GLOBS_ex := \
	target/sol20/games/*.asm \
	target/sol20/stdio/*.asm 


SOL20_TARGETS := target/sol20/obj/target-sol20-sol20 classic/games/obj/.stamp-sol20 classic/gfx/obj/.stamp-sol20
		

CLEAN += target-sol20-clean
TOCREATE += $(call check_target,sol20,sol20_clib.lib)

$(eval $(call gfx_stamp_portable_args,sol20,TARGET=sol20 FLAVOUR=gencon))
$(eval $(call buildtargetasm,target/sol20,8080,sol20,-m8080,$(SOL20_GLOBS),$(SOL20_GLOBS_ex)))

sol20_clib.lib: $(TARGET_CLIB_DEPS) $(SOL20_TARGETS)
	TARGET=sol20 TYPE=8080 $(LIBLINKER) -m8080 -DFORsol20 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sol20_clib @$(TARGET_DIRECTORY)/sol20/sol20.lst


target-sol20: $(SOL20_TARGETS)

.PHONY: target-sol20 target-sol20-clean



target-sol20-clean:
	$(RM) -fr target/sol20/obj
