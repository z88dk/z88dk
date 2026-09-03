PPS_GLOBS := \
	"target/zx/classic//psg/*.asm"  \
	"target/pps/stdio/*.asm"  \
	"target/pps/stdio/ansi/*.asm"  \
	"target/pps/fcntl/*.asm"  

PPS_GLOBS_ex := \
	target/zx/classic//psg/*.asm  \
	target/pps/stdio/*.asm  \
	target/pps/stdio/ansi/*.asm  \
	target/pps/fcntl/*.asm  


PPS_CFILES = $(wildcard target/pps/fcntl/*.c) $(wildcard target/pps/time/*.c)

PPS_OFILES = $(patsubst target/pps/%,target/pps/obj/pps/%,$(PPS_CFILES:.c=.o))



PPS_TARGETS := target/pps/obj/target-pps-pps \
classic/games/obj/.stamp-pps classic/gfx/obj/.stamp-pps \
	$(PPS_OFILES)

$(eval $(call gfx_stamp_args,pps,TARGET=pps))
CLEAN += target-pps-clean
TOCREATE += $(call check_target,pps,pps_clib.lib)
$(eval $(call buildtargetasm,target/pps,z80,pps,-mz80,$(PPS_GLOBS),$(PPS_GLOBS_ex)))
$(eval $(call buildtargetc,target/pps,pps))

pps_clib.lib: $(TARGET_CLIB_DEPS) $(PPS_TARGETS)
	TARGET=pps TYPE=z80 $(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pps_clib @$(TARGET_DIRECTORY)/pps/pps.lst

		


target-pps: $(PPS_TARGETS)

.PHONY: target-pps target-pps-clean


target-pps-clean:
	$(RM) -fr target/pps/obj
