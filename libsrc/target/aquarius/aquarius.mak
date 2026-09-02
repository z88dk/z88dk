AQUARIUS_SOURCES := $(shell find target/aquarius -type f -name '*.asm')
AQUARIUS_CFILES := $(shell find target/aquarius -type f -name '*.c')
AQUARIUS_OFILES := $(patsubst target/aquarius/%,target/aquarius/obj/aquarius/%,$(AQUARIUS_CFILES:.c=.o))

AQUARIUS_TARGETS := target/aquarius/obj/target-aquarius-aquarius $(AQUARIUS_OFILES) classic/games/obj/.stamp-aquarius classic/gfx/obj/.stamp-aquarius

CLEAN += target-aquarius-clean

$(eval $(call gfx_stamp_args,aquarius,TARGET=aquarius FLAVOUR="text6 narrow"))
$(eval $(call gfx_stamp_args,aq48,TARGET=aquarius SUBTYPE=aq48 FLAVOUR="text narrow"))
$(eval $(call gfx_stamp_args,aqplus,TARGET=aquarius SUBTYPE=aqplus FLAVOUR=wide))

target-aquarius: $(AQUARIUS_TARGETS)

.PHONY: target-aquarius target-aquarius-clean

$(eval $(call buildtargetasm,target/aquarius,z80,aquarius,-mz80,$(AQUARIUS_SOURCES),$(AQUARIUS_SOURCES)))
$(eval $(call buildtargetc,target/aquarius,aquarius))

target-aquarius-clean:
	$(RM) -fr target/aquarius/obj
