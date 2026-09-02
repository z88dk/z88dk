MZ_GLOBS := \
	"target/mz/*.asm"  \
	"target/mz/graphics/*.asm" \
	"target/mz/stdio/*.asm" \
	"target/mz/stdio/ansi/*.asm" \
	"target/mz/tape/*.asm"  

MZ_GLOBS_ex := \
	target/mz/*.asm  \
	target/mz/graphics/*.asm \
	target/mz/stdio/*.asm \
	target/mz/stdio/ansi/*.asm \
	target/mz/tape/*.asm  


MZ_CFILES = $(wildcard target/mz/tape/*.c) 

MZ_OFILES = $(patsubst target/mz/%,target/mz/obj/mz/%,$(MZ_CFILES:.c=.o))



MZ_TARGETS := target/mz/obj/target-mz-mz \
classic/games/obj/.stamp-mz classic/gfx/obj/.stamp-mz \
	$(MZ_OFILES)
		

CLEAN += target-mz-clean
mz_clib.lib: $(TARGET_CLIB_DEPS) $(MZ_TARGETS)
	@echo ''
	@echo '--- Building Sharp MZ Library ---'
	@echo ''
	TARGET=mz TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmz -x$(OUTPUT_DIRECTORY)/mz_clib @$(TARGET_DIRECTORY)/mz/mz.lst

TOCREATE += $(call check_target,mz,mz_clib.lib)

$(eval $(call gfx_stamp_args,mz,TARGET=mz))

target-mz: $(MZ_TARGETS)

.PHONY: target-mz target-mz-clean

$(eval $(call buildtargetasm,target/mz,z80,mz,-mz80,$(MZ_GLOBS),$(MZ_GLOBS_ex)))
$(eval $(call buildtargetc,target/mz,mz))

target-mz-clean:
	$(RM) -fr target/mz/obj
