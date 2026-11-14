
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
	$(addprefix classic/sdcard/obj/ez80_z80/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/8080/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/8085/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/gbz80/,$(SDCARD_OBJECTS)) \
	$(addprefix classic/sdcard/obj/vm1/,$(SDCARD_OBJECTS))

OBJS += $(SDCARD_OBJS)
CLEAN += sdcard-clean

$(eval $(call buildbit,classic/sdcard,z80,test))
$(eval $(call buildbit,classic/sdcard,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/sdcard,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/sdcard,r4k,test,-clib=rabbitr4k,-mr4k))
$(eval $(call buildbit,classic/sdcard,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/sdcard,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/sdcard,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,classic/sdcard,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/sdcard,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/sdcard,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/sdcard,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/sdcard,vm1,test,-clib=vm1,-mvm1))

sdcard: $(SDCARD_OBJS)

.PHONY: sdcard sdcard-clean



sdcard-clean:
	$(RM) -fr classic/sdcard/obj classic/sdcard/*.o
