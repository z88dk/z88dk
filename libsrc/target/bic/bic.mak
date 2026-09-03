BIC_GLOBS := \
	"target/bic/psg/*.asm" 

BIC_GLOBS_ex := \
	target/bic/psg/*.asm 


BIC_TARGETS := target/bic/obj/target-bic-bic classic/games/obj/.stamp-cpm-bic
		

CLEAN += target-bic-clean
TOCREATE += $(call check_target,bic,bic.lib $(CPMLIBS))

$(eval $(call buildtargetasm,target/bic,z80,bic,-mz80,$(BIC_GLOBS),$(BIC_GLOBS_ex)))

bic.lib: cpm_clib.lib $(BIC_TARGETS)
	$(MAKE) -C classic/video/upd7220 TARGET=bic
	TARGET=bic TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORbic -x$(OUTPUT_DIRECTORY)/bic @$(TARGET_DIRECTORY)/bic/bic.lst

qx10.lib: cpm_clib.lib
	$(MAKE) -C classic/video/upd7220 TARGET=qx10
	TARGET=qx10 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORqx10 -x$(OUTPUT_DIRECTORY)/qx10 @$(TARGET_DIRECTORY)/bic/bic.lst

target-bic: $(BIC_TARGETS)

.PHONY: target-bic target-bic-clean



target-bic-clean:
	$(RM) -fr target/bic/obj
