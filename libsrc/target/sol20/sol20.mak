SOL20_GLOBS := \
	"target/sol20/games/*.asm" \
	"target/sol20/stdio/*.asm" 

SOL20_GLOBS_ex := \
	target/sol20/games/*.asm \
	target/sol20/stdio/*.asm 


SOL20_TARGETS := target/sol20/obj/target-sol20-sol20
		

CLEAN += target-sol20-clean

target-sol20: $(SOL20_TARGETS)

.PHONY: target-sol20 target-sol20-clean


$(eval $(call buildtargetasm,target/sol20,8080,sol20,-m8080,$(SOL20_GLOBS),$(SOL20_GLOBS_ex)))

target-sol20-clean:
	$(RM) -fr target/sol20/obj
