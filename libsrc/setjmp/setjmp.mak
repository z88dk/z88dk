
SETJMP_CFILES = $(notdir $(wildcard setjmp/*.c))
SETJMP_AFILES = $(notdir $(wildcard setjmp/*.asm))

SETJMP_OBJECTS = $(SETJMP_CFILES:.c=.o) $(SETJMP_AFILES:.asm=.o)

SETJMP_OBJS = $(addprefix setjmp/obj/z80/, $(SETJMP_OBJECTS)) $(addprefix setjmp/obj/r2k/,$(SETJMP_OBJECTS)) $(addprefix setjmp/obj/ixiy/,$(SETJMP_OBJECTS))  $(addprefix setjmp/obj/z80n/,$(SETJMP_OBJECTS)) $(addprefix setjmp/obj/8080/,$(SETJMP_OBJECTS))  $(addprefix setjmp/obj/gbz80/,$(SETJMP_OBJECTS))

OBJS += $(SETJMP_OBJS)
DIRS += setjmp-dirs
CLEAN += setjmp-clean

setjmp: setjmp-dirs $(SETJMP_OBJS)

.PHONY: setjmp setjmp-dirs setjmp-clean

$(eval $(call buildbit,setjmp,z80,test))
$(eval $(call buildbit,setjmp,ixiy,test,-Ca-IXIY))
$(eval $(call buildbit,setjmp,8080,test,-clib=8080))
$(eval $(call buildbit,setjmp,gbz80,test,-clib=gbz80))
$(eval $(call buildbit,setjmp,r2k,test,-clib=rabbit))
$(eval $(call buildbit,setjmp,z80n,test,-clib=z80n))


setjmp-dirs:
	@mkdir -p setjmp/obj/z80 setjmp/obj/r2k setjmp/obj/8080 setjmp/obj/gbz80 setjmp/obj/z80n setjmp/obj/ixiy

setjmp-clean:
	$(RM) -fr setjmp/obj
