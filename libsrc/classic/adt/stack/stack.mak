
STACK_CFILES := $(notdir $(wildcard classic/adt/stack/*.c))
STACK_AFILES := $(notdir $(wildcard classic/adt/stack/*.asm))


STACK_OBJECTS := $(STACK_CFILES:.c=.o) $(STACK_AFILES:.asm=.o)

STACK_OBJS := $(addprefix classic/adt/stack/obj/z80/, $(STACK_OBJECTS)) \
	$(addprefix classic/adt/stack/obj/r2ka/,$(STACK_OBJECTS)) \
	$(addprefix classic/adt/stack/obj/r4k/,$(STACK_OBJECTS)) \
	$(addprefix classic/adt/stack/obj/ixiy/,$(STACK_OBJECTS)) \
	$(addprefix classic/adt/stack/obj/z80n/,$(STACK_OBJECTS)) \
	$(addprefix classic/adt/stack/obj/kc160/,$(STACK_OBJECTS)) \
	$(addprefix classic/adt/stack/obj/z180/,$(STACK_OBJECTS)) \
	$(addprefix classic/adt/stack/obj/ez80_z80/,$(STACK_OBJECTS)) 


OBJS += $(STACK_OBJS) 
CLEAN += classic-adt-stack-clean

classic-adt-stack: $(STACK_OBJS) $(STACK_NEWLIB_TARGETS)

.PHONY: classic-adt-stack classic-adt-stack-clean

$(eval $(call buildbit,classic/adt/stack,z80,test))
$(eval $(call buildbit,classic/adt/stack,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/adt/stack,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/adt/stack,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/adt/stack,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/adt/stack,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,classic/adt/stack,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/adt/stack,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


classic-adt-stack-clean:
	$(RM) -fr classic/adt/stack/obj classic/adt/stack/*.o
