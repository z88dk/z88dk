
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
CUSTOBJECTS = bit_frequency.o bit_play.o psg_play.o joystick_type.o

ifeq ($(SUBSET),)
ASMFILES = $(wildcard *.asm)
else
ASMFILES = $(SUBSET)
endif

OBJECTS = $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)) 

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^ -Ca-I../ -Ca-DFOR$(SUBTYPE)

dirs:
	@mkdir -p obj/$(OBJSUBDIR)

clean:
	$(RM) -fr obj
	$(RM) -f *.o
	$(RM) -f */*.o
	$(RM) zcc_opt.def
