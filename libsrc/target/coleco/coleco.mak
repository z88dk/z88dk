COLECO_GLOBS := \
	"target/coleco/games/*.asm" \
	"target/coleco/stdio/*.asm"

COLECO_GLOBS_ex := \
	target/coleco/games/*.asm \
	target/coleco/stdio/*.asm


COLECO_TARGETS := target/coleco/obj/target-coleco-coleco classic/video/tms9918/obj/coleco classic/games/obj/.stamp-coleco classic/gfx/obj/.stamp-coleco


CLEAN += target-coleco-clean
coleco_clib.lib: $(TARGET_CLIB_DEPS) $(COLECO_TARGETS)
	@echo ''
	@echo '--- Building Colecovision Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=coleco
	TARGET=coleco TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -x$(OUTPUT_DIRECTORY)/coleco_clib @$(TARGET_DIRECTORY)/coleco/coleco.lst

TOCREATE += $(call check_target,coleco,coleco_clib.lib)

$(eval $(call gfx_stamp_args,coleco,TARGET=coleco))
$(eval $(call gfx_stamp_args,cpm-coleco,TARGET=coleco FLAVOUR=narrow))

target-coleco: $(COLECO_TARGETS)

.PHONY: target-coleco target-coleco-clean

$(eval $(call buildtms9918,coleco,coleco))

$(eval $(call buildtargetasm,target/coleco,z80,coleco,-mz80,$(COLECO_GLOBS),$(COLECO_GLOBS_ex)))

target-coleco-clean:
	$(RM) -fr target/coleco/obj
