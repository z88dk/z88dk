
STACK_CFILES = $(notdir $(wildcard adt/stack/*.c))
STACK_AFILES = $(notdir $(wildcard adt/stack/*.asm))


STACK_OBJECTS = $(STACK_CFILES:.c=.o) $(STACK_AFILES:.asm=.o)

STACK_OBJS = $(addprefix adt/stack/obj/z80/, $(STACK_OBJECTS)) \
	$(addprefix adt/stack/obj/r2k/,$(STACK_OBJECTS)) \
	$(addprefix adt/stack/obj/ixiy/,$(STACK_OBJECTS)) \
	$(addprefix adt/stack/obj/z80n/,$(STACK_OBJECTS)) \
	$(addprefix adt/stack/obj/z180/,$(STACK_OBJECTS)) \
	$(addprefix adt/stack/obj/ez80_z80/,$(STACK_OBJECTS)) 


OBJS += $(STACK_OBJS) 
CLEAN += adt-stack-clean

adt-stack: $(STACK_OBJS) $(STACK_NEWLIB_TARGETS)

.PHONY: adt-stack adt-stack-clean

$(eval $(call buildbit,adt/stack,z80,test))
$(eval $(call buildbit,adt/stack,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,adt/stack,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,adt/stack,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,adt/stack,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,adt/stack,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


adt-stack-clean:
	$(RM) -fr adt/stack/obj adt/stack/*.o
