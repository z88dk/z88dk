
X11_CFILES = $(notdir $(wildcard gfx/x11/*.c))
X11_AFILES = $(notdir $(wildcard gfx/x11/*.asm))


X11_OBJECTS = $(X11_CFILES:.c=.o) $(X11_AFILES:.asm=.o)

X11_OBJS = $(addprefix gfx/x11/obj/z80/, $(X11_OBJECTS)) $(addprefix gfx/x11/obj/r2k/,$(X11_OBJECTS)) $(addprefix gfx/x11/obj/ixiy/,$(X11_OBJECTS))  $(addprefix gfx/x11/obj/z80n/,$(X11_OBJECTS)) \
	$(addprefix gfx/x11/obj/z180/,$(X11_OBJECTS)) \
	$(addprefix gfx/x11/obj/8080/,$(X11_OBJECTS)) \
	$(addprefix gfx/x11/obj/gbz80/,$(X11_OBJECTS))


OBJS += $(X11_OBJS) 
CLEAN += gfx-x11-clean

gfx-x11: $(X11_OBJS) $(X11_NEWLIB_TARGETS)

.PHONY: gfx-x11 gfx-x11-clean

$(eval $(call buildbit,gfx/x11,z80,test))
$(eval $(call buildbit,gfx/x11,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,gfx/x11,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,gfx/x11,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,gfx/x11,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,gfx/x11,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,gfx/x11,z180,test,-clib=z180,-mz180))


gfx-x11-clean:
	$(RM) -fr gfx/x11/obj gfx/x11/*.o
