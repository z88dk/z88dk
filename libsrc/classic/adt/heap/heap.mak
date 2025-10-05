
HEAP_CFILES := $(notdir $(wildcard classic/adt/heap/*.c))
HEAP_AFILES := $(notdir $(wildcard classic/adt/heap/*.asm))


HEAP_OBJECTS := $(HEAP_CFILES:.c=.o) $(HEAP_AFILES:.asm=.o)

HEAP_OBJS := $(addprefix classic/adt/heap/obj/z80/, $(HEAP_OBJECTS)) \
	$(addprefix classic/adt/heap/obj/r2ka/,$(HEAP_OBJECTS)) \
	$(addprefix classic/adt/heap/obj/r4k/,$(HEAP_OBJECTS)) \
	$(addprefix classic/adt/heap/obj/ixiy/,$(HEAP_OBJECTS)) \
	$(addprefix classic/adt/heap/obj/z80n/,$(HEAP_OBJECTS)) \
	$(addprefix classic/adt/heap/obj/kc160/,$(HEAP_OBJECTS)) \
	$(addprefix classic/adt/heap/obj/z180/,$(HEAP_OBJECTS)) \
	$(addprefix classic/adt/heap/obj/ez80_z80/,$(HEAP_OBJECTS)) 


OBJS += $(HEAP_OBJS) 
CLEAN += classic-adt-heap-clean

classic-adt-heap: $(HEAP_OBJS) $(HEAP_NEWLIB_TARGETS)

.PHONY: classic-adt-heap classic-adt-heap-clean

$(eval $(call buildbit,classic/adt/heap,z80,test))
$(eval $(call buildbit,classic/adt/heap,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/adt/heap,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/adt/heap,r4k,test,-clib=rabbitr4k,-mr4k))
$(eval $(call buildbit,classic/adt/heap,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/adt/heap,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,classic/adt/heap,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/adt/heap,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


classic-adt-heap-clean:
	$(RM) -fr classic/adt/heap/obj classic/adt/heap/*.o
