MZ2500_GLOBS := \
	"target/mz2500/stdio/*.asm"  

MZ2500_GLOBS_ex := \
	target/mz2500/stdio/*.asm 


MZ2500_CFILES = $(wildcard target/mz2500/tape/*.c) 

MZ2500_OFILES = $(patsubst target/mz2500/%,target/mz2500/obj/mz2500/%,$(MZ2500_CFILES:.c=.o))



MZ2500_TARGETS := target/mz2500/obj/target-mz2500-mz2500 \
	$(MZ2500_OFILES) \
	classic/games/obj/.stamp-cpm-mz2500 classic/gfx/obj/.stamp-mz2500
		

CLEAN += target-mz2500-clean
TOCREATE += $(call check_target,mz2500,mz2500_clib.lib)
$(eval $(call gfx_stamp_args,mz2500,TARGET=mz2500))
$(eval $(call buildtargetasm,target/mz2500,z80,mz2500,-mz80,$(MZ2500_GLOBS),$(MZ2500_GLOBS_ex)))
$(eval $(call buildtargetc,target/mz2500,mz2500))

mz2500_clib.lib: $(TARGET_CLIB_DEPS) $(MZ2500_TARGETS)
	@echo ''
	@echo '--- Building Sharp MZ-2500 Library ---'
	@echo ''
	TARGET=mz2500 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmz2500 -x$(OUTPUT_DIRECTORY)/mz2500_clib @$(TARGET_DIRECTORY)/mz2500/mz2500.lst



target-mz2500: $(MZ2500_TARGETS)

.PHONY: target-mz2500 target-mz2500-clean


target-mz2500-clean:
	$(RM) -fr target/mz2500/obj
