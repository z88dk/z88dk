
include ../../Make.config


TARGET ?= test

CFLAGS += $(TARGET_CFLAGS)

ifeq ($(SUBTYPE),)
SUBTYPE=$(TARGET)
OBJSUBDIR = $(TARGET)
else
OBJSUBDIR = $(SUBTYPE)
endif

ASM_TARGET ?= $(SUBTYPE)

GENOBJECTS =
CUSTOBJECTS = bit_frequency.o bit_play.o buzzer_play.o synth_play.o psg_play.o bit_save_zx.o joystick_type.o bit_load_msx.o bit_load_vg5000.o

ifeq ($(SUBSET),)
ASMFILES = $(wildcard *.asm)
else
ASMFILES = $(SUBSET)
endif

OBJECTS = $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

.PHONY: dirs

all: $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS))

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^ -Ca-I../../ -Ca-DFOR$(ASM_TARGET)

obj/zxn/%.o: %.c
	$(ZCC) +$(TARGET) -clib=classic $(CFLAGS) -o $@  $^

# Order-only: dirs must finish before any object compiles. See Make.config.
$(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)): | dirs

dirs:
	$(Q)mkdir -p obj/$(OBJSUBDIR)

clean:
	$(RM) -fr obj
