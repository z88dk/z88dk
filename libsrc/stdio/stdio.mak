


STDIO_CFILES = $(notdir $(wildcard stdio/*.c)) 

STDIO_NET_CFILES = $(STDIO_CFILES) \
		$(patsubst %,zsock/%,$(notdir $(wildcard stdio/zsock/*.c)))

STDIO_AFILES = $(notdir $(wildcard stdio/*.asm)) \
		$(patsubst %,conio/%,$(notdir $(wildcard stdio/conio/*.asm))) \
		$(patsubst %,ansi/%,$(notdir $(wildcard stdio/ansi/*.asm))) \
		$(patsubst %,ansi/generic/%,$(notdir $(wildcard stdio/ansi/generic/*.asm))) \
		$(patsubst %,ansi/gencon/%,$(notdir $(wildcard stdio/ansi/gencon/*.asm)))

STDIO_8080_AFILES = $(notdir $(wildcard stdio/*.asm))  \
		$(patsubst %,conio/%,$(notdir $(wildcard stdio/conio/*.asm)))
STDIO_GBZ80_AFILES = $(notdir $(filter-out $(wildcard stdio/*scanf*.asm),$(wildcard stdio/*.asm))) \
		$(patsubst %,conio/%,$(notdir $(wildcard stdio/conio/*.asm)))

STDIO_OBJECTS = $(STDIO_CFILES:.c=.o) $(STDIO_AFILES:.asm=.o)
STDIO_8080_OBJECTS = $(STDIO_CFILES:.c=.o) $(STDIO_8080_AFILES:.asm=.o)
STDIO_GBZ80_OBJECTS = $(STDIO_CFILES:.c=.o) $(STDIO_GBZ80_AFILES:.asm=.o)

STDIO_OBJS = $(addprefix stdio/obj/z80/, $(STDIO_OBJECTS)) \
	$(addprefix stdio/obj/z80/, $(STDIO_NET_CFILES:.c=.o)) \
	$(addprefix stdio/obj/ixiy/,$(STDIO_OBJECTS)) \
	$(addprefix stdio/obj/z80-binary/,$(STDIO_OBJECTS)) \
	$(addprefix stdio/obj/r2k/,$(STDIO_OBJECTS)) \
	$(addprefix stdio/obj/8080/,$(STDIO_8080_OBJECTS)) \
	$(addprefix stdio/obj/8085/,$(STDIO_8080_OBJECTS)) \
	$(addprefix stdio/obj/8080-binary/,$(STDIO_8080_OBJECTS)) \
	$(addprefix stdio/obj/gbz80/,$(STDIO_GBZ80_OBJECTS)) \
	$(addprefix stdio/obj/ez80_z80/,$(STDIO_OBJECTS)) \
	$(addprefix stdio/obj/z80n/,$(STDIO_OBJECTS)) 

OBJS += $(STDIO_OBJS)
CLEAN += stdio-clean

stdio: $(STDIO_OBJS)

.PHONY: stdio stdio-clean

$(eval $(call buildbit,stdio,z80,test))
$(eval $(call buildbit,stdio,z80-binary,cpm))
$(eval $(call buildbit,stdio,ixiy,test,-Ca-IXIY,-mz80 -IXIY))
$(eval $(call buildbit,stdio,8080,test,-DCPU_8080 -clib=8080,-m8080))
$(eval $(call buildbit,stdio,8085,test,-DCPU_8080 -clib=8085,-m8085))
$(eval $(call buildbit,stdio,8080-binary,cpm,-DCPU_8080 -clib=8080,-m8080))
$(eval $(call buildbit,stdio,gbz80,test,-DCPU_GBZ80 -clib=gbz80,-mgbz80))
$(eval $(call buildbit,stdio,r2k,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,stdio,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,stdio,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,stdio,ez80_z80,test,-clib=ez80_z80,-mez80_z80))


stdio-clean:
	$(RM) -fr stdio/obj
