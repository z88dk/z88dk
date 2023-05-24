
RECT_CFILES = $(notdir $(wildcard rect/*.c))
RECT_AFILES = $(notdir $(wildcard rect/*.asm))

RECT_OBJECTS = $(RECT_CFILES:.c=.o) $(RECT_AFILES:.asm=.o)

RECT_OBJS = $(addprefix rect/obj/z80/, $(RECT_OBJECTS)) $(addprefix rect/obj/r2k/,$(RECT_OBJECTS)) $(addprefix rect/obj/ixiy/,$(RECT_OBJECTS))  $(addprefix rect/obj/z80n/,$(RECT_OBJECTS)) 

OBJS += $(RECT_OBJS)
CLEAN += rect-clean

rect: $(RECT_OBJS)

.PHONY: rect rect-clean

$(eval $(call buildbit,rect,z80,test))
$(eval $(call buildbit,rect,ixiy,test,-Ca-IXIY))
$(eval $(call buildbit,rect,8080,test,-clib=8080))
$(eval $(call buildbit,rect,gbz80,test,-clib=gbz80))
$(eval $(call buildbit,rect,r2k,test,-clib=rabbit))
$(eval $(call buildbit,rect,z80n,test,-clib=z80n))


rect-clean:
	$(RM) -fr rect/obj
