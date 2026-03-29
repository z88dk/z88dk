AGON_GLOBS := \
	"target/agon/agon/*.asm" \
	"target/agon/graphics/*.asm" \
	"target/agon/fcntl/*.asm" \
	"target/agon/stdio/*.asm" 

AGON_GLOBS_ex := \
	target/agon/agon/*.asm \
	target/agon/graphics/*.asm \
	target/agon/fcntl/*.asm \
	target/agon/stdio/*.asm 


AGON_TARGETS := target/agon/obj/target-agon-agon
		

CLEAN += target-agon-clean

target-agon: $(AGON_TARGETS)

.PHONY: target-agon target-agon-clean


$(eval $(call buildtargetasm,target/agon,ez80_z80,agon,-mez80_z80,$(AGON_GLOBS),$(AGON_GLOBS_ex)))

target-agon-clean:
	$(RM) -fr target/agon/obj
