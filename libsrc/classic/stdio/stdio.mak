


STDIO_CFILES := $(notdir $(wildcard classic/stdio/*.c)) 

STDIO_NET_CFILES := $(STDIO_CFILES) \
		$(patsubst %,zsock/%,$(notdir $(wildcard classic/stdio/zsock/*.c)))

STDIO_AFILES := $(notdir $(wildcard classic/stdio/*.asm)) \
		$(patsubst %,conio/%,$(notdir $(wildcard classic/stdio/conio/*.asm))) \
		$(patsubst %,ansi/%,$(notdir $(wildcard classic/stdio/ansi/*.asm))) \
		$(patsubst %,inkey/%,$(notdir $(wildcard classic/stdio/inkey/*.asm))) \
		$(patsubst %,ansi/generic/%,$(notdir $(wildcard classic/stdio/ansi/generic/*.asm))) \
		$(patsubst %,ansi/gencon/%,$(notdir $(wildcard classic/stdio/ansi/gencon/*.asm)))

STDIO_8080_AFILES := $(notdir $(wildcard classic/stdio/*.asm))  \
		$(patsubst %,conio/%,$(notdir $(wildcard classic/stdio/conio/*.asm))) \
		$(patsubst %,inkey/%,$(notdir $(wildcard classic/stdio/inkey/*.asm)))

STDIO_8085_AFILES := $(notdir $(wildcard classic/stdio/*.asm))  \
		$(patsubst %,conio/%,$(notdir $(wildcard classic/stdio/conio/*.asm))) \
		$(patsubst %,inkey/%,$(notdir $(wildcard classic/stdio/inkey/*.asm)))

STDIO_GBZ80_AFILES := $(notdir $(filter-out $(wildcard classic/stdio/*scanf*.asm),$(wildcard classic/stdio/*.asm))) \
		$(patsubst %,conio/%,$(notdir $(wildcard classic/stdio/conio/*.asm))) \
		$(patsubst %,inkey/%,$(notdir $(wildcard classic/stdio/inkey/*.asm)))

STDIO_OBJECTS := $(STDIO_CFILES:.c=.o) $(STDIO_AFILES:.asm=.o)
STDIO_8080_OBJECTS := $(STDIO_CFILES:.c=.o) $(STDIO_8080_AFILES:.asm=.o)
STDIO_8085_OBJECTS := $(STDIO_CFILES:.c=.o) $(STDIO_8085_AFILES:.asm=.o)
STDIO_GBZ80_OBJECTS := $(STDIO_CFILES:.c=.o) $(STDIO_GBZ80_AFILES:.asm=.o)

STDIO_OBJS := $(addprefix classic/stdio/obj/z80/, $(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/z80/, $(STDIO_NET_CFILES:.c=.o)) \
	$(addprefix classic/stdio/obj/ixiy/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/z80-binary/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/z180/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/z180-binary/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/ixiy-binary/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/r2ka/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/r4k/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/8080/,$(STDIO_8080_OBJECTS)) \
	$(addprefix classic/stdio/obj/8085/,$(STDIO_8085_OBJECTS)) \
	$(addprefix classic/stdio/obj/8080-binary/,$(STDIO_8080_OBJECTS)) \
	$(addprefix classic/stdio/obj/8085-binary/,$(STDIO_8085_OBJECTS)) \
	$(addprefix classic/stdio/obj/gbz80/,$(STDIO_GBZ80_OBJECTS)) \
	$(addprefix classic/stdio/obj/ez80_z80/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/kc160/,$(STDIO_OBJECTS)) \
	$(addprefix classic/stdio/obj/z80n/,$(STDIO_OBJECTS)) 

OBJS += $(STDIO_OBJS)
CLEAN += classic-stdio-clean

classic-stdio: $(STDIO_OBJS)

.PHONY: classic-stdio classic-stdio-clean

$(eval $(call buildbit,classic/stdio,z80,test))
$(eval $(call buildbit,classic/stdio,z80-binary,cpm))
$(eval $(call buildbit,classic/stdio,ixiy,test,-Ca-IXIY,-mz80 -IXIY))
$(eval $(call buildbit,classic/stdio,ixiy-binary,cpm,-Ca-IXIY,-mz80 -IXIY))
$(eval $(call buildbit,classic/stdio,8080,test,-DCPU_8080 -clib=8080,-m8080))
$(eval $(call buildbit,classic/stdio,8085,test,-DCPU_8085 -clib=8085,-m8085))
$(eval $(call buildbit,classic/stdio,8080-binary,cpm,-DCPU_8080 -clib=8080,-m8080))
$(eval $(call buildbit,classic/stdio,8085-binary,cpm,-DCPU_8085 -clib=8085,-m8085))
$(eval $(call buildbit,classic/stdio,gbz80,test,-DCPU_GBZ80 -clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/stdio,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/stdio,r4k,test,-clib=rabbit4k,-mr4k))
$(eval $(call buildbit,classic/stdio,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/stdio,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/stdio,z180-binary,cpm,-clib=z180,-mz180))
$(eval $(call buildbit,classic/stdio,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/stdio,kc160,test,-clib=kc160,-mkc160))


classic-stdio-clean:
	$(RM) -fr classic/stdio/obj
