
SDCARD_CFILES := $(notdir $(wildcard sdcard/*.c))
SDCARD_AFILES := $(notdir $(wildcard sdcard/*.asm))

SDCARD_OBJECTS := $(SDCARD_CFILES:.c=.o) $(SDCARD_AFILES:.asm=.o)

SDCARD_OBJS := $(addprefix sdcard/obj/z80/, $(SDCARD_OBJECTS)) \
	$(addprefix sdcard/obj/r2ka/,$(SDCARD_OBJECTS)) \
	$(addprefix sdcard/obj/r4k/,$(SDCARD_OBJECTS)) \
	$(addprefix sdcard/obj/ixiy/,$(SDCARD_OBJECTS)) \
	$(addprefix sdcard/obj/z80n/,$(SDCARD_OBJECTS)) \
	$(addprefix sdcard/obj/z180/,$(SDCARD_OBJECTS)) \
	$(addprefix sdcard/obj/kc160/,$(SDCARD_OBJECTS)) \
	$(addprefix sdcard/obj/ez80_z80/,$(SDCARD_OBJECTS))

OBJS += $(SDCARD_OBJS)
CLEAN += sdcard-clean

sdcard: $(SDCARD_OBJS)

.PHONY: sdcard sdcard-clean

$(eval $(call buildbit,sdcard,z80,test))
$(eval $(call buildbit,sdcard,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,sdcard,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,sdcard,r4k,test,-clib=rabbitr4k,-mr4k))
$(eval $(call buildbit,sdcard,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,sdcard,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,sdcard,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,sdcard,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


sdcard-clean:
	$(RM) -fr sdcard/obj sdcard/*.o
