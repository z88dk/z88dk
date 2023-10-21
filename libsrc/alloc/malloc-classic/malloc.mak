
MALLOC_CFILES := $(notdir $(wildcard alloc/malloc-classic/*.c))
MALLOC_AFILES := $(notdir $(wildcard alloc/malloc-classic/*.asm))

MALLOC_NEWLIBGLOBS := 
MALLOC_NEWLIBGLOBS_ex := 

MALLOC_NEWLIB_TARGETS := 

MALLOC_OBJECTS := $(MALLOC_CFILES:.c=.o) $(MALLOC_AFILES:.asm=.o)

MALLOC_OBJS := $(addprefix alloc/malloc-classic/obj/z80/, $(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/r2ka/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/r4k/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/ixiy/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/z80n/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/8080/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/gbz80/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/z180/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/ez80_z80/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/kc160/,$(MALLOC_OBJECTS))


OBJS += $(MALLOC_OBJS) $(MALLOC_NEWLIB_TARGETS)
CLEAN += alloc-malloc-clean

alloc-malloc: $(MALLOC_OBJS) $(MALLOC_NEWLIB_TARGETS)

.PHONY: alloc-malloc alloc-malloc-clean

$(eval $(call buildbit,alloc/malloc-classic,z80,test))
$(eval $(call buildbit,alloc/malloc-classic,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,alloc/malloc-classic,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,alloc/malloc-classic,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,alloc/malloc-classic,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,alloc/malloc-classic,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,alloc/malloc-classic,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,alloc/malloc-classic,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,alloc/malloc-classic,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,alloc/malloc-classic,kc160,test,-clib=kc160,-mkc160))


alloc/malloc-classic/obj/%:
	@mkdir -p $@

alloc-malloc-clean:
	$(RM) -fr alloc/malloc-classic/obj alloc/malloc-classic/*.o
	
