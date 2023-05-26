
STDIO_CFILES = $(notdir $(wildcard stdio/*.c))
STDIO_AFILES = $(notdir $(wildcard stdio/*.asm))

STDIO_OBJECTS = $(STDIO_CFILES:.c=.o) $(STDIO_AFILES:.asm=.o)

STDIO_OBJS = $(addprefix stdio/obj/z80, $(STDIO_OBJECTS)) $(addprefix stdio/obj/ixiy/,$(STDIO_OBJECTS)) \
		$(addprefix stdio/obj/net/,$(STDIO_ZS_OBJECTS)) $(addprefix stdio/obj/stdesc/,$(STDIO_OBJECTS)) \
		$(addprefix stdio/obj/r2k/,$(STDIO_OBJECTS)) \
		$(addprefix stdio/obj/8080/,$(STDIO_8080_OBJECTS)) $(addprefix stdio/obj/gbz80/,$(STDIO_GBZ80_OBJECTS))

OBJS += $(STDIO_OBJS)
CLEAN += stdio-clean

stdio: $(STDIO_OBJS)

.PHONY: stdio stdio-clean

$(eval $(call buildbit,stdio,z80,test))
$(eval $(call buildbit,stdio,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,stdio,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,stdio,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,stdio,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,stdio,z80n,test,-clib=z80n,-mz80n))


stdio-clean:
	$(RM) -fr stdio/obj
