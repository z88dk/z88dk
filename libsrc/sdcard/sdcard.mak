
SDCARD_CFILES = $(notdir $(wildcard sdcard/*.c))
SDCARD_AFILES = $(notdir $(wildcard sdcard/*.asm))

SDCARD_OBJECTS = $(SDCARD_CFILES:.c=.o) $(SDCARD_AFILES:.asm=.o)

SDCARD_OBJS = $(addprefix sdcard/obj/z80/, $(SDCARD_OBJECTS)) $(addprefix sdcard/obj/r2k/,$(SDCARD_OBJECTS)) $(addprefix sdcard/obj/ixiy/,$(SDCARD_OBJECTS))  $(addprefix sdcard/obj/z80n/,$(SDCARD_OBJECTS)) 

OBJS += $(SDCARD_OBJS)
CLEAN += sdcard-clean

sdcard: $(SDCARD_OBJS)

.PHONY: sdcard sdcard-clean

$(eval $(call buildbit,sdcard,z80,test))
$(eval $(call buildbit,sdcard,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,sdcard,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,sdcard,z80n,test,-clib=z80n,-mz80n))


sdcard-clean:
	$(RM) -fr sdcard/obj sdcard/*.o
