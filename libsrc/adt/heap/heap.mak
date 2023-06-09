
HEAP_CFILES = $(notdir $(wildcard adt/heap/*.c))
HEAP_AFILES = $(notdir $(wildcard adt/heap/*.asm))


HEAP_OBJECTS = $(HEAP_CFILES:.c=.o) $(HEAP_AFILES:.asm=.o)

HEAP_OBJS = $(addprefix adt/heap/obj/z80/, $(HEAP_OBJECTS)) \
	$(addprefix adt/heap/obj/r2k/,$(HEAP_OBJECTS)) \
	$(addprefix adt/heap/obj/ixiy/,$(HEAP_OBJECTS)) \
	$(addprefix adt/heap/obj/z80n/,$(HEAP_OBJECTS)) \
	$(addprefix adt/heap/obj/ez80_z80/,$(HEAP_OBJECTS)) 


OBJS += $(HEAP_OBJS) 
CLEAN += adt-heap-clean

adt-heap: $(HEAP_OBJS) $(HEAP_NEWLIB_TARGETS)

.PHONY: adt-heap adt-heap-clean

$(eval $(call buildbit,adt/heap,z80,test))
$(eval $(call buildbit,adt/heap,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,adt/heap,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,adt/heap,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,adt/heap,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


adt-heap-clean:
	$(RM) -fr adt/heap/obj adt/heap/*.o
