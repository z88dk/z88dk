
QUEUE_CFILES = $(notdir $(wildcard adt/queue/*.c))
QUEUE_AFILES = $(notdir $(wildcard adt/queue/*.asm))


QUEUE_OBJECTS = $(QUEUE_CFILES:.c=.o) $(QUEUE_AFILES:.asm=.o)

QUEUE_OBJS = $(addprefix adt/queue/obj/z80/, $(QUEUE_OBJECTS)) \
	$(addprefix adt/queue/obj/r2k/,$(QUEUE_OBJECTS)) \
	$(addprefix adt/queue/obj/ixiy/,$(QUEUE_OBJECTS)) \
	$(addprefix adt/queue/obj/z80n/,$(QUEUE_OBJECTS)) \
	$(addprefix adt/queue/obj/ez80_z80/,$(QUEUE_OBJECTS)) 


OBJS += $(QUEUE_OBJS) 
CLEAN += adt-queue-clean

adt-queue: $(QUEUE_OBJS) $(QUEUE_NEWLIB_TARGETS)

.PHONY: adt-queue adt-queue-clean

$(eval $(call buildbit,adt/queue,z80,test))
$(eval $(call buildbit,adt/queue,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,adt/queue,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,adt/queue,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,adt/queue,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


adt-queue-clean:
	$(RM) -fr adt/queue/obj adt/queue/*.o
