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


VECTOR06C_TARGETS := target/vector06c/obj/target-vector06c-vector06c
		

CLEAN += target-vector06c-clean

target-vector06c: $(VECTOR06C_TARGETS)

.PHONY: target-vector06c target-vector06c-clean


$(eval $(call buildtargetasm,target/vector06c,8080,vector06c,-m8080,$(VECTOR06C_GLOBS),$(VECTOR06C_GLOBS_ex)))

target-vector06c-clean:
	$(RM) -fr target/vector06c/obj
