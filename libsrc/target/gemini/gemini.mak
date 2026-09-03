GEMINI_GLOBS := \
	"target/gemini/graphics/*.asm" \
	"target/gemini/stdio/*.asm" \
	"target/gemini/stdio/ansi/*.asm" 

GEMINI_GLOBS_ex := \
	target/gemini/graphics/*.asm \
	target/gemini/stdio/*.asm  \
	target/gemini/stdio/ansi/*.asm 


GEMINI_TARGETS := target/gemini/obj/target-gemini-gemini classic/games/obj/.stamp-cpm-gemini classic/gfx/obj/.stamp-cpm-gemini
		

CLEAN += target-gemini-clean
TOCREATE += $(call check_target,gemini,gemini.lib $(CPMLIBS))
$(eval $(call buildtargetasm,target/gemini,z80,gemini,-mz80,$(GEMINI_GLOBS),$(GEMINI_GLOBS_ex)))

gemini.lib: cpm_clib.lib $(GEMINI_TARGETS)
	@echo ''
	@echo '--- Building Gemini Galaxy Library (CP/M & graphics) ---'
	@echo ''
	TARGET=gemini TYPE=z80 $(LIBLINKER) -DFORgemini -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gemini.lib @$(TARGET_DIRECTORY)/gemini/gemini.lst


target-gemini: $(GEMINI_TARGETS)

.PHONY: target-gemini target-gemini-clean



target-gemini-clean:
	$(RM) -fr target/gemini/obj
