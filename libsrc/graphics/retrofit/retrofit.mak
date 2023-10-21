
RETROFIT_CFILES := $(notdir $(wildcard graphics/retrofit/*.c))
RETROFIT_AFILES := $(notdir $(wildcard graphics/retrofit/*.asm))

RETROFIT_OBJECTS := $(RETROFIT_CFILES:.c=.o) $(RETROFIT_AFILES:.asm=.o)

RETROFIT_OBJS := $(addprefix graphics/retrofit/obj/z80/, $(RETROFIT_OBJECTS)) \
	$(addprefix graphics/retrofit/obj/r2ka/,$(RETROFIT_OBJECTS)) \
	$(addprefix graphics/retrofit/obj/r4k/,$(RETROFIT_OBJECTS)) \
	$(addprefix graphics/retrofit/obj/ixiy/,$(RETROFIT_OBJECTS)) \
	$(addprefix graphics/retrofit/obj/z80n/,$(RETROFIT_OBJECTS)) \
	$(addprefix graphics/retrofit/obj/8080/,$(RETROFIT_OBJECTS)) \
	$(addprefix graphics/retrofit/obj/z180/,$(RETROFIT_OBJECTS)) \
	$(addprefix graphics/retrofit/obj/ez80_z80/,$(RETROFIT_OBJECTS)) \
	$(addprefix graphics/retrofit/obj/kc160/,$(RETROFIT_OBJECTS))

OBJS += $(RETROFIT_OBJS)
CLEAN += graphics/retrofit-clean

graphics-retrofit: $(RETROFIT_OBJS)

.PHONY: graphics/retrofit graphics/retrofit-clean

$(eval $(call buildbit,graphics/retrofit,z80,test))
$(eval $(call buildbit,graphics/retrofit,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,graphics/retrofit,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,graphics/retrofit,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,graphics/retrofit,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,graphics/retrofit,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,graphics/retrofit,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,graphics/retrofit,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,graphics/retrofit,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,graphics/retrofit,kc160,test,-clib=kc160,-mkc160))


graphics/retrofit-clean:
	$(RM) -fr graphics/retrofit/obj graphics/retrofit/*.o
