TRS80_SOURCES := $(shell find target/trs80 -type f -name '*.asm')
TRS80_CFILES := $(shell find target/trs80 -type f -name '*.c')
TRS80_OFILES := $(addprefix target/trs80/obj/trs80/,$(TRS80_CFILES:.c=.o))

TRS80_TARGETS := target/trs80/obj/target-trs80-trs80 $(TRS80_OFILES) classic/games/obj/.stamp-trs80 classic/gfx/obj/.stamp-trs80-base

CLEAN += target-trs80-clean

target-trs80: $(TRS80_TARGETS)

.PHONY: target-trs80 target-trs80-clean

$(eval $(call buildtargetasm,target/trs80,z80,trs80,-mz80,$(TRS80_SOURCES),$(TRS80_SOURCES)))
$(eval $(call buildtargetc,target/trs80,trs80))

target-trs80-clean:
	$(RM) -fr target/trs80/obj
