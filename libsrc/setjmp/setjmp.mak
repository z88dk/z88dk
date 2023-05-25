
SETJMP_CFILES = $(notdir $(wildcard setjmp/*.c))
SETJMP_AFILES = $(notdir $(wildcard setjmp/*.asm))

SETJMP_OBJECTS = $(SETJMP_CFILES:.c=.o) $(SETJMP_AFILES:.asm=.o)

SETJMP_OBJS = $(addprefix setjmp/obj/z80/, $(SETJMP_OBJECTS)) $(addprefix setjmp/obj/r2k/,$(SETJMP_OBJECTS)) $(addprefix setjmp/obj/ixiy/,$(SETJMP_OBJECTS))  $(addprefix setjmp/obj/z80n/,$(SETJMP_OBJECTS)) $(addprefix setjmp/obj/8080/,$(SETJMP_OBJECTS))  $(addprefix setjmp/obj/gbz80/,$(SETJMP_OBJECTS))

OBJS += $(SETJMP_OBJS)
CLEAN += setjmp-clean

setjmp: $(SETJMP_OBJS)

.PHONY: setjmp setjmp-clean

$(eval $(call buildbit,setjmp,z80,test))
$(eval $(call buildbit,setjmp,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,setjmp,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,setjmp,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,setjmp,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,setjmp,z80n,test,-clib=z80n,-mz80n))


setjmp-clean:
	$(RM) -fr setjmp/obj
