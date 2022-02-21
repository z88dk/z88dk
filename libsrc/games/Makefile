
include ../Make.config


TARGET ?= test

CFLAGS += $(TARGET_CFLAGS)

ifeq ($(SUBTYPE),) 
SUBTYPE=$(TARGET)
OBJSUBDIR = $(TARGET)
else
OBJSUBDIR = $(SUBTYPE)
endif

GENOBJECTS = 
CUSTOBJECTS = bit_frequency.o bit_play.o buzzer_play.o synth_play.o psg_play.o joystick_type.o

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/sound/bit/z80/asm_bit_beepfx/*.asm"

ifeq ($(SUBSET),)
ASMFILES = $(wildcard *.asm)
else
ASMFILES = $(SUBSET)
endif

OBJECTS = $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n obj/newlib-r2k obj/newlib-ixiy obj/newlib-8080 obj/newlib-gbz80

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS))  $(NEWLIB_TARGETS)

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^ -Ca-I../ -Ca-DFOR$(SUBTYPE)

obj/zxn/%.o: %.c
	$(ZCC) +$(TARGET) -clib=classic $(CFLAGS) -o $@  $^


obj/newlib-z80:
	@$(ASSEMBLER) -d -O=obj/z80/x -I.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-r2k:
	@$(ASSEMBLER) -d -O=obj/r2k/x -I.. -mr2ka -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80n:
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-ixiy:
	@$(ASSEMBLER) -d -O=obj/ixiy/x -I.. -mz80 -IXIY -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-8080:
	@$(ASSEMBLER) -d -O=obj/8080/x -I.. -m8080 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-gbz80:
	@$(ASSEMBLER) -d -O=obj/gbz80/x -I.. -mgbz80 -D__CLASSIC $(NEWLIBGLOBS)


dirs:
	@mkdir -p obj/$(OBJSUBDIR) obj/z80 obj/z80n obj/ixiy obj/r2k obj/8080 obj/gbz80

clean:
	$(RM) -fr obj
	$(RM) -f *.o
	$(RM) -f */*.o
	$(RM) zcc_opt.def
