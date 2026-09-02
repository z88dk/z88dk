KAYPRO83_GLOBS := \
	"target/kaypro83/*.asm" 

KAYPRO83_GLOBS_ex := \
	target/kaypro83/*.asm 


KAYPRO83_TARGETS := target/kaypro83/obj/target-kaypro83-kaypro83 classic/gfx/obj/.stamp-cpm-kaypro83
		

CLEAN += target-kaypro83-clean
gfxkp83.lib: cpm_clib.lib $(KAYPRO83_TARGETS)
	TARGET=kaypro83 TYPE=z80 $(LIBLINKER) -DFORkaypro83 -I$(Z88DK_LIB) -x$(OUTPUT_DIRECTORY)/gfxkp83 @$(TARGET_DIRECTORY)/kaypro83/gfxkp83.lst

TOCREATE += $(call check_target,kaypro83,gfxkp83.lib $(CPMLIBS))

target-kaypro83: $(KAYPRO83_TARGETS)

.PHONY: target-kaypro83 target-kaypro83-clean


$(eval $(call buildtargetasm,target/kaypro83,z80,kaypro83,-mz80,$(KAYPRO83_GLOBS),$(KAYPRO83_GLOBS_ex)))

target-kaypro83-clean:
	$(RM) -fr target/kaypro83/obj
