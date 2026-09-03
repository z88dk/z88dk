ADAM_GLOBS := \
	"target/adam/*.asm"

ADAM_GLOBS_ex := \
	target/adam/*.asm


ADAM_TARGETS := target/adam/obj/target-adam-adam classic/games/obj/.stamp-coleco classic/gfx/obj/.stamp-coleco


CLEAN += target-adam-clean
TOCREATE += $(call check_target,adam,adam.lib $(CPMLIBS))
$(eval $(call buildtargetasm,target/adam,z80,adam,-mz80,$(ADAM_GLOBS),$(ADAM_GLOBS_ex)))

adam.lib: coleco_clib.lib $(ADAM_TARGETS)
	@echo ''
	@echo '--- Building Coleco Adam Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=coleco
	TARGET=coleco TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -DFORadam -x$(OUTPUT_DIRECTORY)/adam @$(TARGET_DIRECTORY)/adam/adam.lst


target-adam: $(ADAM_TARGETS)

.PHONY: target-adam target-adam-clean


target-adam-clean:
	$(RM) -fr target/adam/obj
