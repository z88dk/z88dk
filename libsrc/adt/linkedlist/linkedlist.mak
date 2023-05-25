
LINKEDLIST_CFILES = $(notdir $(wildcard adt/linkedlist/*.c))
LINKEDLIST_AFILES = $(notdir $(wildcard adt/linkedlist/*.asm))


LINKEDLIST_OBJECTS = $(LINKEDLIST_CFILES:.c=.o) $(LINKEDLIST_AFILES:.asm=.o)

LINKEDLIST_OBJS = $(addprefix adt/linkedlist/obj/z80/, $(LINKEDLIST_OBJECTS)) $(addprefix adt/linkedlist/obj/r2k/,$(LINKEDLIST_OBJECTS)) $(addprefix adt/linkedlist/obj/ixiy/,$(LINKEDLIST_OBJECTS))  $(addprefix adt/linkedlist/obj/z80n/,$(LINKEDLIST_OBJECTS)) 


OBJS += $(LINKEDLIST_OBJS) 
CLEAN += adt-linkedlist-clean

adt-linkedlist: $(LINKEDLIST_OBJS) $(LINKEDLIST_NEWLIB_TARGETS)

.PHONY: adt-linkedlist adt-linkedlist-clean

$(eval $(call buildbit,adt/linkedlist,z80,test))
$(eval $(call buildbit,adt/linkedlist,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,adt/linkedlist,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,adt/linkedlist,z80n,test,-clib=z80n,-mz80n))


adt-linkedlist-clean:
	$(RM) -fr adt/linkedlist/obj
