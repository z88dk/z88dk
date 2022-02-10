
include ../../Make.config


TARGET ?= test

ifeq ($(SUBTYPE),) 
SUBTYPE=$(TARGET)
OBJSUBDIR = $(TARGET)
ASMFLAGS = -DFOR$(TARGET)
CFLAGS += -Ca-DFOR$(TARGET) -Ca-I../..
else
OBJSUBDIR = $(SUBTYPE)
CFLAGS += -subtype=$(SUBTYPE) -Ca-DFOR$(SUBTYPE) -Ca-I../../
ASMFLAGS = -DFOR$(SUBTYPE)
endif

CFILES = 
ASMFILES = $(wildcard stdio/*.asm) $(wildcard graphics/*.asm)

OBJECTS = $(CFILES:.c=.o) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)) 

obj/$(OBJSUBDIR)/%.o: %.c
	@mkdir -p $(dirname $@)
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

dirs:
	@mkdir -p obj/$(OBJSUBDIR)/stdio obj/$(OBJSUBDIR)/graphics

clean: 
	$(RM) -fr obj zcc_opt.def *.err

