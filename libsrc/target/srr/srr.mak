SRR_GLOBS := \
	"target/srr/games/*.asm"  \
	"target/srr/graphics/*.asm"  \
	"target/srr/input/*.asm"  \
	"target/srr/srr/*.asm"  \
	"target/srr/stdio/*.asm"  

SRR_GLOBS_ex := \
	target/srr/games/*.asm  \
	target/srr/graphics/*.asm  \
	target/srr/input/*.asm  \
	target/srr/srr/*.asm  \
	target/srr/stdio/*.asm  


SRR_CFILES = $(wildcard target/srr/srr/*.c) 

SRR_OFILES = $(patsubst target/srr/%,target/srr/obj/srr/%,$(SRR_CFILES:.c=.o))



SRR_TARGETS := target/srr/obj/target-srr-srr \
	$(SRR_OFILES) \
	classic/games/obj/.stamp-srr classic/gfx/obj/.stamp-srr

$(eval $(call gfx_stamp_args,srr,TARGET=srr FLAVOUR="gencon narrow"))
		

CLEAN += target-srr-clean
TOCREATE += $(call check_target,srr,srr_clib.lib)

srr_clib.lib: $(TARGET_CLIB_DEPS) $(SRR_TARGETS)
	TARGET=srr TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsorcerer -x$(OUTPUT_DIRECTORY)/srr_clib @$(TARGET_DIRECTORY)/srr/srr.lst

target-srr: $(SRR_TARGETS)

.PHONY: target-srr target-srr-clean

$(eval $(call buildtargetasm,target/srr,z80,srr,-mz80,$(SRR_GLOBS),$(SRR_GLOBS_ex)))
$(eval $(call buildtargetc,target/srr,srr))

target-srr-clean:
	$(RM) -fr target/srr/obj
