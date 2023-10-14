
LINKEDLIST_CFILES := $(notdir $(wildcard adt/linkedlist/*.c))
LINKEDLIST_AFILES := $(notdir $(wildcard adt/linkedlist/*.asm))


LINKEDLIST_OBJECTS := $(LINKEDLIST_CFILES:.c=.o) $(LINKEDLIST_AFILES:.asm=.o)

LINKEDLIST_OBJS := $(addprefix adt/linkedlist/obj/z80/, $(LINKEDLIST_OBJECTS)) \
	$(addprefix adt/linkedlist/obj/r2ka/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix adt/linkedlist/obj/r4k/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix adt/linkedlist/obj/ixiy/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix adt/linkedlist/obj/z80n/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix adt/linkedlist/obj/kc160/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix adt/linkedlist/obj/z180/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix adt/linkedlist/obj/ez80_z80/,$(LINKEDLIST_OBJECTS)) 


OBJS += $(LINKEDLIST_OBJS) 
CLEAN += adt-linkedlist-clean

adt-linkedlist: $(LINKEDLIST_OBJS) $(LINKEDLIST_NEWLIB_TARGETS)

.PHONY: adt-linkedlist adt-linkedlist-clean

$(eval $(call buildbit,adt/linkedlist,z80,test))
$(eval $(call buildbit,adt/linkedlist,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,adt/linkedlist,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,adt/linkedlist,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,adt/linkedlist,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,adt/linkedlist,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,adt/linkedlist,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,adt/linkedlist,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


adt-linkedlist-clean:
	$(RM) -fr adt/linkedlist/obj adt/linkedlist/*.o
