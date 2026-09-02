
include ../../../Make.config


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

OBJECTS = $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

all: $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS))

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@ -O0 $^ -Ca-I../../.. -Ca-DFOR$(SUBTYPE)

# Order-only: dirs must finish before any object compiles. See Make.config.
$(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)): | dirs

dirs:
	$(Q)mkdir -p obj/$(OBJSUBDIR)

clean:
	$(RM) -fr obj
	$(RM) -f *.o
	$(RM) -f */*.o
