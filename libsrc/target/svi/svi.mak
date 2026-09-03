SVI_SOURCES := $(call rwildcard,target/svi,*.asm) $(call rwildcard,target/svi,*.c) $(call rwildcard,target/svi,Makefile)

SVI_TARGETS := \
	target/svi/obj/target-svi-support \
	target/svi/obj/target-svi-msx \
	classic/video/tms9918/obj/svi \
	classic/video/mc6845/obj/svi \
	classic/games/obj/.stamp-svi \
	classic/gfx/obj/.stamp-svi

CLEAN += target-svi-clean
TOCREATE += $(call check_target,svi,svi_clib.lib svibios.lib)
$(eval $(call gfx_stamp_args,svi,TARGET=svi))
$(eval $(call buildvideo,tms9918,TMS9918,svi,))
$(eval $(call buildvideo,mc6845,MC6845,svi,))

svi_clib.lib: $(TARGET_CLIB_DEPS) msx_clib.lib $(SVI_TARGETS)
	TARGET=svi TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsvi -x$(OUTPUT_DIRECTORY)/svi_clib @$(TARGET_DIRECTORY)/svi/svi.lst

svibios.lib: $(TARGET_CLIB_DEPS) msx_clib.lib $(SVI_TARGETS)
	TARGET=svi TYPE=z80 $(LIBLINKER) -DFORsvi -x$(OUTPUT_DIRECTORY)/svibios @$(TARGET_DIRECTORY)/svi/arch_svibios.lst

target/svi/obj/target-svi-support: $(SVI_SOURCES)
	$(Q)mkdir -p $(dir $@)
	$(MAKE) -C target/svi
	@touch $@

target/svi/obj/target-svi-msx: $(MSX_GLOBS_ex)
	$(Q)mkdir -p target/svi/obj/msx
	$(Q)$(ASSEMBLER) -d -O=target/svi/obj/msx/x -m4=-I$(Z88DK_LIB)/../src/m4 -m4=-I$(Z88DK_LIBSRC)/target/svi -I$(Z88DK_LIB) -I$(Z88DK_LIBSRC)/target/svi/def -Itarget/svi -Itarget/svi/obj/msx -I$(Z88DK_LIBSRC)/classic -mz80 -DSTANDARDESCAPECHARS -I$(Z88DK_LIB) -D__CLASSIC -DFORsvi $(MSX_GLOBS)
	$(Q)touch $@



target-svi: $(SVI_TARGETS)

.PHONY: target-svi target-svi-clean

target-svi-clean:
	$(RM) -fr target/svi/obj target/svi/rs232/obj target/svi/svibios/obj
