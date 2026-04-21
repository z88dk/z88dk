KAYPRO83_GLOBS := \
	"target/kaypro83/*.asm" 

KAYPRO83_GLOBS_ex := \
	target/kaypro83/*.asm 


KAYPRO83_TARGETS := target/kaypro83/obj/target-kaypro83-kaypro83
		

CLEAN += target-kaypro83-clean

target-kaypro83: $(KAYPRO83_TARGETS)

.PHONY: target-kaypro83 target-kaypro83-clean


$(eval $(call buildtargetasm,target/kaypro83,z80,kaypro83,-mz80,$(KAYPRO83_GLOBS),$(KAYPRO83_GLOBS_ex)))

target-kaypro83-clean:
	$(RM) -fr target/kaypro83/obj
