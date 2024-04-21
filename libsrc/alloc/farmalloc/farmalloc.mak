
farmalloc_CFILES := $(notdir $(wildcard alloc/farmalloc/*.c))
farmalloc_AFILES := $(notdir $(wildcard alloc/farmalloc/*.asm))

farmalloc_OBJECTS := $(farmalloc_CFILES:.c=.o) $(farmalloc_AFILES:.asm=.o)

farmalloc_OBJS := $(addprefix alloc/farmalloc/obj/z80/, $(farmalloc_OBJECTS)) \
	$(addprefix alloc/farmalloc/obj/r2ka/,$(farmalloc_OBJECTS)) \
	$(addprefix alloc/farmalloc/obj/ixiy/,$(farmalloc_OBJECTS)) \
	$(addprefix alloc/farmalloc/obj/z80n/,$(farmalloc_OBJECTS)) \
	$(addprefix alloc/farmalloc/obj/ez80_z80/,$(farmalloc_OBJECTS)) \
	$(addprefix alloc/farmalloc/obj/z180/,$(farmalloc_OBJECTS)) \
	$(addprefix alloc/farmalloc/obj/r4k/,$(farmalloc_OBJECTS)) \
	$(addprefix alloc/farmalloc/obj/kc160/,$(farmalloc_OBJECTS))

OBJS += $(farmalloc_OBJS)
CLEAN += farmalloc-clean

farmalloc: $(farmalloc_OBJS)

.PHONY: farmalloc farmalloc-clean

$(eval $(call buildbit,alloc/farmalloc,z80,test))
$(eval $(call buildbit,alloc/farmalloc,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,alloc/farmalloc,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,alloc/farmalloc,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,alloc/farmalloc,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,alloc/farmalloc,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,alloc/farmalloc,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,alloc/farmalloc,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,alloc/farmalloc,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,alloc/farmalloc,kc160,test,-clib=kc160,-mkc160))


farmalloc-clean:
	$(RM) -fr alloc/farmalloc/obj farmalloc/*.o
