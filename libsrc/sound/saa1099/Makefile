
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
ASMFILES = $(wildcard *.asm) $(wildcard etracker/*.asm) ayemul/saa_ayemul.asm
else
ASMFILES = $(SUBSET)
endif


.PHONY: dirs $(NEWLIBTARGETS)

OBJECTS = $(CUSTOBJECTS) $(ASMFILES:.asm=.o) 

all: dirs $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)) $(NEWLIBTARGETS)

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^ -Ca-I../.. -Ca-DFOR$(SUBTYPE)


dirs:
	@mkdir -p obj/$(OBJSUBDIR) obj/$(OBJSUBDIR)/etracker obj/$(OBJSUBDIR)/ayemul

clean:
	$(RM) -fr obj
	$(RM) -f *.o
	$(RM) -f */*.o
