
include ../../Make.config


TARGET ?= test

CFLAGS += $(TARGET_CFLAGS)

ifeq ($(SUBTYPE),) 
SUBTYPE=$(TARGET)
OBJSUBDIR = $(TARGET)
else
OBJSUBDIR = $(SUBTYPE)
endif

GENOBJECTS = 

ifeq ($(SUBSET),)
ASMFILES = $(wildcard *.asm)
else
ASMFILES = $(SUBSET)
endif

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/sound/sn76489/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/sound/sn76489/z80/*.asm"

NEWLIBTARGETS := obj/$(OBJSUBDIR)/newlib

.PHONY: dirs $(NEWLIBTARGETS)

OBJECTS = $(CUSTOBJECTS) $(ASMFILES:.asm=.o) 

all: dirs $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)) $(NEWLIBTARGETS)

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^ -Ca-I../.. -Ca-DFOR$(SUBTYPE)

obj/$(OBJSUBDIR)/newlib:
	@$(ASSEMBLER) -d -O=obj/$(OBJSUBDIR)/newlib/x -I. -mz80 -D__CLASSIC -DFOR$(SUBTYPE) $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/$(OBJSUBDIR)

clean:
	$(RM) -fr obj
	$(RM) -f *.o
	$(RM) -f */*.o
