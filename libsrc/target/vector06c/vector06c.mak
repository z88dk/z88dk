VECTOR06C_GLOBS := \
	"target/vector06c/*.asm" \
	"target/vector06c/games/*.asm" \
	"target/vector06c/graphics/*.asm" \
	"target/vector06c/input/*.asm" \
	"target/vector06c/psg/*.asm" \
	"target/vector06c/stdio/*.asm" 

VECTOR06C_GLOBS_ex := \
	target/vector06c/*.asm \
	target/vector06c/games/*.asm \
	target/vector06c/graphics/*.asm \
	target/vector06c/input/*.asm \
	target/vector06c/psg/*.asm \
	target/vector06c/stdio/*.asm 


VECTOR06C_TARGETS := target/vector06c/obj/target-vector06c-vector06c classic/games/obj/.stamp-vector06c classic/gfx/obj/.stamp-vector06c classic/gfx/obj/.stamp-vector06c-portable
		

CLEAN += target-vector06c-clean
TOCREATE += $(call check_target,vector06c,vector06c_clib.lib)

$(eval $(call gfx_stamp_args,vector06c,TARGET=vector06c FLAVOUR=wide))
$(eval $(call gfx_stamp_portable,vector06c-portable,vector06c))
$(eval $(call buildtargetasm,target/vector06c,8080,vector06c,-m8080,$(VECTOR06C_GLOBS),$(VECTOR06C_GLOBS_ex)))

vector06c_clib.lib: $(TARGET_CLIB_DEPS) $(VECTOR06C_TARGETS)
	TARGET=vector06c TYPE=8080 $(LIBLINKER) -m8080 -DFORvector06c -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vector06c_clib @$(TARGET_DIRECTORY)/vector06c/vector06c.lst


target-vector06c: $(VECTOR06C_TARGETS)

.PHONY: target-vector06c target-vector06c-clean



target-vector06c-clean:
	$(RM) -fr target/vector06c/obj
