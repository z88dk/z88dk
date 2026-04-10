ATTACHE_GLOBS := \
	"target/attache/bios/*.asm" \
	"target/attache/graphics/*.asm" \
	"target/attache/psg/*.asm" \
	"target/attache/time/*.asm" 

ATTACHE_GLOBS_ex := \
	target/attache/bios/*.asm \
	target/attache/graphics/*.asm \
	target/attache/psg/*.asm \
	target/attache/time/*.asm


ATTACHE_TARGETS := target/attache/obj/target-attache-attache
		

CLEAN += target-attache-clean

target-attache: $(ATTACHE_TARGETS)

.PHONY: target-attache target-attache-clean


$(eval $(call buildtargetasm,target/attache,z80,attache,-mz80,$(ATTACHE_GLOBS),$(ATTACHE_GLOBS_ex)))

target-attache-clean:
	$(RM) -fr target/attache/obj
