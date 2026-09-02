OZ_SOURCES := $(shell find target/oz -type f -name '*.asm')
OZ_CFILES := $(shell find target/oz -type f -name '*.c')
OZ_OFILES := $(patsubst target/oz/%,target/oz/obj/oz/%,$(OZ_CFILES:.c=.o))

OZ_TARGETS := target/oz/obj/target-oz-oz $(OZ_OFILES) classic/games/obj/.stamp-oz classic/gfx/obj/.stamp-oz

ozansi_clib.lib: $(TARGET_CLIB_DEPS) $(OZ_TARGETS)
	TARGET=oz TYPE=z80 $(LIBLINKER) -DFORoz -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ozansi_clib @$(TARGET_DIRECTORY)/oz/oz.lst

$(eval $(call gfx_stamp_args,oz,TARGET=oz))

CLEAN += target-oz-clean
TOCREATE += $(call check_target,oz,ozansi_clib.lib)

target-oz: $(OZ_TARGETS)

.PHONY: target-oz target-oz-clean

$(eval $(call buildtargetasm,target/oz,z80,oz,-mz80,$(OZ_SOURCES),$(OZ_SOURCES)))
$(eval $(call buildtargetc,target/oz,oz))

target-oz-clean:
	$(RM) -fr target/oz/obj
