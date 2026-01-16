
ALLOC_FARMALLOC_CFILES := $(notdir $(wildcard classic/alloc/farmalloc/*.c))
ALLOC_FARMALLOC_AFILES := $(notdir $(wildcard classic/alloc/farmalloc/*.asm))

ALLOC_FARMALLOC_OBJECTS := $(ALLOC_FARMALLOC_CFILES:.c=.o) $(ALLOC_FARMALLOC_AFILES:.asm=.o)

ALLOC_FARMALLOC_OBJS := $(addprefix classic/alloc/farmalloc/obj/z80/, $(ALLOC_FARMALLOC_OBJECTS)) \
	$(addprefix classic/alloc/farmalloc/obj/r2ka/,$(ALLOC_FARMALLOC_OBJECTS)) \
	$(addprefix classic/alloc/farmalloc/obj/ixiy/,$(ALLOC_FARMALLOC_OBJECTS)) \
	$(addprefix classic/alloc/farmalloc/obj/z80n/,$(ALLOC_FARMALLOC_OBJECTS)) \
	$(addprefix classic/alloc/farmalloc/obj/ez80_z80/,$(ALLOC_FARMALLOC_OBJECTS)) \
	$(addprefix classic/alloc/farmalloc/obj/z180/,$(ALLOC_FARMALLOC_OBJECTS)) \
	$(addprefix classic/alloc/farmalloc/obj/r4k/,$(ALLOC_FARMALLOC_OBJECTS)) \
	$(addprefix classic/alloc/farmalloc/obj/kc160/,$(ALLOC_FARMALLOC_OBJECTS))

OBJS += $(ALLOC_FARMALLOC_OBJS)
CLEAN += alloc-farmalloc-clean

alloc-farmalloc: $(ALLOC_FARMALLOC_OBJS)

.PHONY: alloc-farmalloc alloc-farmalloc-clean

$(eval $(call buildbit,classic/alloc/farmalloc,z80,test))
$(eval $(call buildbit,classic/alloc/farmalloc,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/alloc/farmalloc,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/alloc/farmalloc,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/alloc/farmalloc,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/alloc/farmalloc,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/alloc/farmalloc,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/alloc/farmalloc,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/alloc/farmalloc,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/alloc/farmalloc,kc160,test,-clib=kc160,-mkc160))


alloc-farmalloc-clean:
	$(RM) -fr classic/alloc/farmalloc/obj
