GB_SOURCES := $(shell find target/gb -type f -name '*.asm')

GB_TARGETS := target/gb/obj/target-gb-gb classic/games/obj/.stamp-gb classic/gfx/obj/.stamp-gb

CLEAN += target-gb-clean

$(eval $(call gfx_stamp_args,gb,TARGET=gb FLAVOUR="gencon portable"))

target-gb: $(GB_TARGETS)

.PHONY: target-gb target-gb-clean

$(eval $(call buildtargetasm,target/gb,gbz80,gb,-mgbz80,$(GB_SOURCES),$(GB_SOURCES)))

target-gb-clean:
	$(RM) -fr target/gb/obj
