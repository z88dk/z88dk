
GFXPORTABLE_CFILES := $(notdir $(wildcard gfx/portable/*.c))
GFXPORTABLE_AFILES := $(notdir $(wildcard gfx/portable/*.asm))


GFXPORTABLE_OBJECTS := $(GFXPORTABLE_CFILES:.c=.o) $(GFXPORTABLE_AFILES:.asm=.o)

GFXPORTABLE_OBJS := $(addprefix gfx/portable/obj/ixiy/,$(GFXPORTABLE_OBJECTS)) \
	$(addprefix gfx/portable/obj/8080/,$(GFXPORTABLE_OBJECTS)) \
	$(addprefix gfx/portable/obj/8085/,$(GFXPORTABLE_OBJECTS)) \
	$(addprefix gfx/portable/obj/z180/,$(GFXPORTABLE_OBJECTS)) \
	$(addprefix gfx/portable/obj/gbz80/,$(GFXPORTABLE_OBJECTS))


OBJS += $(GFXPORTABLE_OBJS) 
CLEAN += gfx-portable-clean

gfx-portable: $(GFXPORTABLE_OBJS) $(GFXPORTABLE_NEWLIB_TARGETS)

.PHONY: gfx-portable gfx-portable-clean

$(eval $(call buildbit,gfx/portable,z80,test))
$(eval $(call buildbit,gfx/portable,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,gfx/portable,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,gfx/portable,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,gfx/portable,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,gfx/portable,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,gfx/portable,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,gfx/portable,z180,test,-clib=z180,-mz180))


gfx-portable-clean:
	$(RM) -fr gfx/portable/obj gfx/portable/*.o
