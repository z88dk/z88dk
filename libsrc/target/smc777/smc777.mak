SMC777_SOURCES := $(call rwildcard,target/smc777,*.asm)
SMC777_TARGETS := target/smc777/obj/target-smc777-smc777 \
	classic/video/mc6845/obj/smc777

$(eval $(call gfx_stamp_args,smc777,TARGET=smc777 FLAVOUR=wide))
$(eval $(call buildvideo,mc6845,MC6845,smc777,))
CLEAN += target-smc777-clean
TOCREATE += $(call check_target,smc777,smc777_clib.lib smc777_cpm.lib $(CPMLIBS))
$(eval $(call buildtargetasm,target/smc777,z80,smc777,-mz80,$(SMC777_SOURCES),$(SMC777_SOURCES)))

smc777_clib.lib: $(TARGET_CLIB_DEPS) $(SMC777_TARGETS) classic/games/obj/.stamp-smc777 classic/gfx/obj/.stamp-smc777
	TARGET=smc777 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsmc777 -x$(OUTPUT_DIRECTORY)/smc777_clib @$(TARGET_DIRECTORY)/smc777/smc777.lst

smc777_cpm.lib: smc777_clib.lib $(SMC777_TARGETS) classic/games/obj/.stamp-cpm-smc777 classic/gfx/obj/.stamp-cpm-smc777
	TARGET=smc777 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsmc777 -x$(OUTPUT_DIRECTORY)/smc777_cpm @$(TARGET_DIRECTORY)/smc777/smc777_cpm.lst

target-smc777: $(SMC777_TARGETS)

.PHONY: target-smc777 target-smc777-clean

target-smc777-clean:
	$(RM) -fr target/smc777/obj
