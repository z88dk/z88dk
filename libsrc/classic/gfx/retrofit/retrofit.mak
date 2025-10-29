
RETROFIT_CFILES := $(notdir $(wildcard classic/gfx/retrofit/*.c))
RETROFIT_AFILES := $(notdir $(wildcard classic/gfx/retrofit/*.asm))

RETROFIT_OBJECTS := $(RETROFIT_CFILES:.c=.o) $(RETROFIT_AFILES:.asm=.o)

RETROFIT_OBJS := $(addprefix classic/gfx/retrofit/obj/z80/, $(RETROFIT_OBJECTS)) \
	$(addprefix classic/gfx/retrofit/obj/r2ka/,$(RETROFIT_OBJECTS)) \
	$(addprefix classic/gfx/retrofit/obj/r4k/,$(RETROFIT_OBJECTS)) \
	$(addprefix classic/gfx/retrofit/obj/ixiy/,$(RETROFIT_OBJECTS)) \
	$(addprefix classic/gfx/retrofit/obj/z80n/,$(RETROFIT_OBJECTS)) \
	$(addprefix classic/gfx/retrofit/obj/8080/,$(RETROFIT_OBJECTS)) \
	$(addprefix classic/gfx/retrofit/obj/z180/,$(RETROFIT_OBJECTS)) \
	$(addprefix classic/gfx/retrofit/obj/ez80_z80/,$(RETROFIT_OBJECTS)) \
	$(addprefix classic/gfx/retrofit/obj/kc160/,$(RETROFIT_OBJECTS))

OBJS += $(RETROFIT_OBJS)
CLEAN += classic-gfx-retrofit-clean

classic-gfx-retrofit: $(RETROFIT_OBJS)

.PHONY: classic-gfx-retrofit classic-gfx-retrofit-clean

$(eval $(call buildbit,classic/gfx/retrofit,z80,test))
$(eval $(call buildbit,classic/gfx/retrofit,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/gfx/retrofit,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/gfx/retrofit,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/gfx/retrofit,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/gfx/retrofit,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/gfx/retrofit,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/gfx/retrofit,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/gfx/retrofit,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/gfx/retrofit,kc160,test,-clib=kc160,-mkc160))


classic-gfx-retrofit-clean:
	$(RM) -fr classic/gfx/retrofit/obj classic/gfx/retrofit/*.o
