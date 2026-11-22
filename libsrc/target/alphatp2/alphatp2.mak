

ALPHATP2_GLOBS := \
	"target/alphatp2/stdio/*.asm" \
	"target/alphatp2/graphics/*.asm" 

ALPHATP2_GLOBS_ex := \
	target/alphatp2/stdio/*.asm \
	target/alphatp2/graphics/*.asm 



ALPHATP2_CFILES = 

ALPHATP2_OFILES = $(patsubst target/alphatp2/%,target/alphatp2/obj/alphatp2/%,$(ALPHATP2_CFILES:.c=.o))



ALPHATP2_TARGETS := target/alphatp2/obj/target-alphatp2-alphatp2  $(ALPHATP2_OFILES) classic/games/obj/.stamp-alphatp2 classic/gfx/obj/.stamp-alphatp2
		

CLEAN += target-alphatp2-clean
TOCREATE += $(call check_target,alphatp2,alphatp2_clib.lib)
$(eval $(call gfx_stamp_args,alphatp2,TARGET=alphatp2 FLAVOUR="gencon narrow"))
$(eval $(call buildtargetasm,target/alphatp2,8080,alphatp2,-m8080,$(ALPHATP2_GLOBS),$(ALPHATP2_GLOBS_ex)))
$(eval $(call buildtargetc,target/alphatp2,alphatp2))

alphatp2_clib.lib: $(TARGET_CLIB_DEPS) $(ALPHATP2_TARGETS)
	@echo ''
	@echo '--- Building Alpha P2 Library ---'
	@echo ''
	TARGET=alphatp2 TYPE=8080 $(LIBLINKER) -m8080 -DSTANDARDESCAPECHARS -DFORalphatp2 -x$(OUTPUT_DIRECTORY)/alphatp2_clib @$(TARGET_DIRECTORY)/alphatp2/alphatp2.lst




target-alphatp2: $(ALPHATP2_TARGETS)

.PHONY: target-alphatp2 target-alphatp2-clean




target-alphatp2-clean:
	$(RM) -fr target/alphatp2/obj
