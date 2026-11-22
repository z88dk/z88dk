S1MP3_GLOBS := \
	"target/s1mp3/stdio/*.asm"

S1MP3_GLOBS_ex := \
	target/s1mp3/stdio/*.asm

S1MP3_CFILES = $(wildcard target/s1mp3/*/*.c)

S1MP3_OFILES = $(patsubst target/s1mp3/%,target/s1mp3/obj/s1mp3/%,$(S1MP3_CFILES:.c=.o))


S1MP3_TARGETS := target/s1mp3/obj/target-s1mp3-s1mp3 \
	$(S1MP3_OFILES) \
	classic/gfx/obj/.stamp-s1mp3


CLEAN += target-s1mp3-clean
TOCREATE += $(call check_target,s1mp3,s1mp3_clib.lib)
$(eval $(call gfx_stamp_args,s1mp3,TARGET=s1mp3))
$(eval $(call buildtargetasm,target/s1mp3,z80,s1mp3,-mz80,$(S1MP3_GLOBS),$(S1MP3_GLOBS_ex)))
$(eval $(call buildtargetc,target/s1mp3,s1mp3))

s1mp3_clib.lib: $(TARGET_CLIB_DEPS) $(S1MP3_TARGETS)
	@echo ''
	@echo '--- Building s1mp3 Library ---'
	@echo ''
	TARGET=s1mp3 TYPE=z80 $(LIBLINKER) -DFORs1mp3 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/s1mp3_clib.lib @$(TARGET_DIRECTORY)/s1mp3/s1mp3.lst



target-s1mp3: $(S1MP3_TARGETS)

.PHONY: target-s1mp3 target-s1mp3-clean


target-s1mp3-clean:
	$(RM) -fr target/s1mp3/obj
