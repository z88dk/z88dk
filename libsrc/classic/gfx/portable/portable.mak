
GFXPORTABLE_CFILES := $(notdir $(wildcard classic/gfx/portable/*.c))
GFXPORTABLE_AFILES := $(notdir $(wildcard classic/gfx/portable/*.asm))


GFXPORTABLE_OBJECTS := $(GFXPORTABLE_CFILES:.c=.o) $(GFXPORTABLE_AFILES:.asm=.o)

GFXPORTABLE_OBJS := $(addprefix classic/gfx/portable/obj/ixiy/,$(GFXPORTABLE_OBJECTS)) \
	$(addprefix classic/gfx/portable/obj/8080/,$(GFXPORTABLE_OBJECTS)) \
	$(addprefix classic/gfx/portable/obj/8085/,$(GFXPORTABLE_OBJECTS)) \
	$(addprefix classic/gfx/portable/obj/z180/,$(GFXPORTABLE_OBJECTS)) \
	$(addprefix classic/gfx/portable/obj/gbz80/,$(GFXPORTABLE_OBJECTS))


OBJS += $(GFXPORTABLE_OBJS) 
CLEAN += gfx-portable-clean

gfx-portable: $(GFXPORTABLE_OBJS) $(GFXPORTABLE_NEWLIB_TARGETS)

.PHONY: gfx-portable gfx-portable-clean

$(eval $(call buildbit,classic/gfx/portable,z80,test))
$(eval $(call buildbit,classic/gfx/portable,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/gfx/portable,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/gfx/portable,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/gfx/portable,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/gfx/portable,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/gfx/portable,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/gfx/portable,z180,test,-clib=z180,-mz180))


gfx-portable-clean:
	$(RM) -fr classic/gfx/portable/obj classic/gfx/portable/*.o
