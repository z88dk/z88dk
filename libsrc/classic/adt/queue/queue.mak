
QUEUE_CFILES := $(notdir $(wildcard classic/adt/queue/*.c))
QUEUE_AFILES := $(notdir $(wildcard classic/adt/queue/*.asm))


QUEUE_OBJECTS := $(QUEUE_CFILES:.c=.o) $(QUEUE_AFILES:.asm=.o)

QUEUE_OBJS := $(addprefix classic/adt/queue/obj/z80/, $(QUEUE_OBJECTS)) \
	$(addprefix classic/adt/queue/obj/r2ka/,$(QUEUE_OBJECTS)) \
	$(addprefix classic/adt/queue/obj/r4k/,$(QUEUE_OBJECTS)) \
	$(addprefix classic/adt/queue/obj/ixiy/,$(QUEUE_OBJECTS)) \
	$(addprefix classic/adt/queue/obj/z80n/,$(QUEUE_OBJECTS)) \
	$(addprefix classic/adt/queue/obj/kc160/,$(QUEUE_OBJECTS)) \
	$(addprefix classic/adt/queue/obj/z180/,$(QUEUE_OBJECTS)) \
	$(addprefix classic/adt/queue/obj/ez80_z80/,$(QUEUE_OBJECTS)) 


OBJS += $(QUEUE_OBJS) 
CLEAN += classic-adt-queue-clean

classic-adt-queue: $(QUEUE_OBJS) $(QUEUE_NEWLIB_TARGETS)

.PHONY: classic-adt-queue classic-adt-queue-clean

$(eval $(call buildbit,classic/adt/queue,z80,test))
$(eval $(call buildbit,classic/adt/queue,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/adt/queue,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/adt/queue,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/adt/queue,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/adt/queue,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,classic/adt/queue,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/adt/queue,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


classic-adt-queue-clean:
	$(RM) -fr classic/adt/queue/obj classic/adt/queue/*.o
