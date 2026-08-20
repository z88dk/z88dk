ZXVGS_GLOBS := \
	"target/zxvgs/fcntl/*.asm" \
	"target/zxvgs/games/*.asm" \
	"target/zxvgs/zxvgs/*.asm"

ZXVGS_GLOBS_ex := \
	target/zxvgs/fcntl/*.asm \
	target/zxvgs/games/*.asm \
	target/zxvgs/zxvgs/*.asm


ZXVGS_TARGETS := target/zxvgs/obj/target-zxvgs-zxvgs


CLEAN += target-zxvgs-clean

target-zxvgs: $(ZXVGS_TARGETS)

.PHONY: target-zxvgs target-zxvgs-clean

$(eval $(call buildtargetasm,target/zxvgs,z80,zxvgs,-mz80,$(ZXVGS_GLOBS),$(ZXVGS_GLOBS_ex)))

target-zxvgs-clean:
	$(RM) -fr target/zxvgs/obj
