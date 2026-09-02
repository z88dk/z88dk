
include ../../../Make.config


TARGET ?= test

ifeq ($(SUBTYPE),) 
SUBTYPE=$(TARGET)
OBJSUBDIR = $(TARGET)
ASMFLAGS = -DFOR$(TARGET)
CFLAGS += -Ca-DFOR$(TARGET) -Ca-I../../..
else
OBJSUBDIR = $(SUBTYPE)
CFLAGS += -subtype=$(SUBTYPE) -Ca-DFOR$(SUBTYPE) -Ca-I../../../
ASMFLAGS = -DFOR$(SUBTYPE)
endif

CFILES = 
ASMFILES = $(wildcard stdio/*.asm) $(wildcard graphics/*.asm)

OBJECTS = $(CFILES:.c=.o) $(ASMFILES:.asm=.o)

all: $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS))

obj/$(OBJSUBDIR)/%.o: %.c
	$(Q)mkdir -p $(dirname $@)
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

# Order-only: dirs must finish before any object compiles. See Make.config.
$(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)): | dirs

dirs:
	$(Q)mkdir -p obj/$(OBJSUBDIR)/stdio obj/$(OBJSUBDIR)/graphics

clean: 
	$(RM) -fr obj zcc_opt.def *.err

