
MALLOC_CFILES = $(notdir $(wildcard alloc/malloc-classic/*.c))
MALLOC_AFILES = $(notdir $(wildcard alloc/malloc-classic/*.asm))

MALLOC_NEWLIBGLOBS := 
MALLOC_NEWLIBGLOBS_ex := 

MALLOC_NEWLIB_TARGETS := 

MALLOC_OBJECTS = $(MALLOC_CFILES:.c=.o) $(MALLOC_AFILES:.asm=.o)

MALLOC_OBJS = $(addprefix alloc/malloc-classic/obj/z80/, $(MALLOC_OBJECTS)) $(addprefix alloc/malloc-classic/obj/r2k/,$(MALLOC_OBJECTS)) $(addprefix alloc/malloc-classic/obj/ixiy/,$(MALLOC_OBJECTS))  $(addprefix alloc/malloc-classic/obj/z80n/,$(MALLOC_OBJECTS)) \
	$(addprefix alloc/malloc-classic/obj/8080/,$(MALLOC_OBJECTS)) $(addprefix alloc/malloc-classic/obj/gbz80/,$(MALLOC_OBJECTS))


OBJS += $(MALLOC_OBJS) $(MALLOC_NEWLIB_TARGETS)
CLEAN += alloc-malloc-clean

alloc-malloc: $(MALLOC_OBJS) $(MALLOC_NEWLIB_TARGETS)

.PHONY: alloc-malloc alloc-malloc-clean

$(eval $(call buildbit,alloc/malloc-classic,z80,test))
$(eval $(call buildbit,alloc/malloc-classic,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,alloc/malloc-classic,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,alloc/malloc-classic,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,alloc/malloc-classic,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,alloc/malloc-classic,z80n,test,-clib=z80n,-mz80n))


alloc/malloc-classic/obj/newlib-z80-alloc/malloc-classic: $(MALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/malloc-classic/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/malloc-classic/obj/z80/x -I.. -mz80 -D__CLASSIC $(MALLOC_NEWLIBGLOBS)

alloc/malloc-classic/obj/newlib-r2k-alloc-malloc: $(MALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/malloc-classic/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/malloc-classic/obj/r2k/x -I.. -mr2ka -D__CLASSIC $(MALLOC_NEWLIBGLOBS)

alloc/malloc-classic/obj/newlib-z80n-alloc-malloc: $(MALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/malloc-classic/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/malloc-classic/obj/z80n/x -I.. -mz80n -D__CLASSIC $(MALLOC_NEWLIBGLOBS)

alloc/malloc-classic/obj/newlib-ixiy-alloc-malloc: $(MALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/malloc-classic/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/malloc-classic/obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(MALLOC_NEWLIBGLOBS)

alloc/malloc-classic/obj/newlib-8080-alloc-malloc: $(MALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/malloc-classic/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/malloc-classic/obj/8080/x -I.. -m8080 -D__CLASSIC $(MALLOC_NEWLIBGLOBS)

alloc/malloc-classic/obj/newlib-gbz80-alloc-malloc: $(MALLOC_NEWLIBGLOBS_ex)
	@mkdir -p alloc/malloc-classic/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=alloc/malloc-classic/obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(MALLOC_NEWLIBGLOBS)

alloc/malloc-classic/obj/%:
	@mkdir -p $@

alloc-malloc-clean:
	$(RM) -fr alloc/malloc-classic/obj alloc/malloc-classic/*.o
	
