
LINKEDLIST_CFILES := $(notdir $(wildcard classic/adt/linkedlist/*.c))
LINKEDLIST_AFILES := $(notdir $(wildcard classic/adt/linkedlist/*.asm))


LINKEDLIST_OBJECTS := $(LINKEDLIST_CFILES:.c=.o) $(LINKEDLIST_AFILES:.asm=.o)

LINKEDLIST_OBJS := $(addprefix classic/adt/linkedlist/obj/z80/, $(LINKEDLIST_OBJECTS)) \
	$(addprefix classic/adt/linkedlist/obj/r2ka/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix classic/adt/linkedlist/obj/r4k/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix classic/adt/linkedlist/obj/ixiy/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix classic/adt/linkedlist/obj/z80n/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix classic/adt/linkedlist/obj/kc160/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix classic/adt/linkedlist/obj/z180/,$(LINKEDLIST_OBJECTS)) \
	$(addprefix classic/adt/linkedlist/obj/ez80_z80/,$(LINKEDLIST_OBJECTS)) 


OBJS += $(LINKEDLIST_OBJS) 
CLEAN += classic-adt-linkedlist-clean

classic-adt-linkedlist: $(LINKEDLIST_OBJS) $(LINKEDLIST_NEWLIB_TARGETS)

.PHONY: classic-adt-linkedlist classic-adt-linkedlist-clean

$(eval $(call buildbit,classic/adt/linkedlist,z80,test))
$(eval $(call buildbit,classic/adt/linkedlist,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/adt/linkedlist,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/adt/linkedlist,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/adt/linkedlist,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/adt/linkedlist,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,classic/adt/linkedlist,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/adt/linkedlist,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


classic-adt-linkedlist-clean:
	$(RM) -fr classic/adt/linkedlist/obj classic/adt/linkedlist/*.o
