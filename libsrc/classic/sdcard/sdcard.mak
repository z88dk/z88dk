
SDCARD_CFILES := $(notdir $(wildcard classic/sdcard/*.c))
SDCARD_AFILES := $(notdir $(wildcard classic/sdcard/*.asm))

SDCARD_OBJECTS := $(SDCARD_CFILES:.c=.o) $(SDCARD_AFILES:.asm=.o)

SDCARD_OBJS := $(addprefix classic/sdcard/obj/z80/, $(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/r2ka/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/r4k/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/ixiy/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/z80n/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/z180/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/kc160/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/ez80_z80/,$(SDCARD_OBJECTS))

OBJS += $(SDCARD_OBJS)
CLEAN += sdcard-clean

sdcard: $(SDCARD_OBJS)

.PHONY: sdcard sdcard-clean

$(eval $(call buildbit,classic/sdcard,z80,test))
$(eval $(call buildbit,classic/sdcard,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/sdcard,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/sdcard,r4k,test,-clib=rabbitr4k,-mr4k))
$(eval $(call buildbit,classic/sdcard,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/sdcard,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/sdcard,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,classic/sdcard,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


sdcard-clean:
	$(RM) -fr classic/sdcard/obj classic/sdcard/*.o
