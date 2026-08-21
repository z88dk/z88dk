
include ../../../../Make.config


TARGET ?= test

ifeq ($(SUBTYPE),) 
SUBTYPE=$(TARGET)
OBJSUBDIR = $(TARGET)
ASMFLAGS = -DFOR$(TARGET)
else
OBJSUBDIR = $(SUBTYPE)
CFLAGS += -subtype=$(SUBTYPE)
ASMFLAGS = -DFOR$(SUBTYPE)
endif

CFILES = $(wildcard *.c)
ASMFILES = $(wildcard *.asm)

OBJECTS = $(CFILES:.c=.o) $(ASMFILES:.asm=.o)

all: $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS))

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	@$(ASSEMBLER) $(ASMFLAGS) -I$(Z88DK_LIB) -I$(Z88DK_LIB)/../libsrc -Oobj/$(OBJSUBDIR) $^

# Order-only: dirs must finish before any object compiles. See Make.config.
$(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)): | dirs

dirs:
	@mkdir -p obj/$(OBJSUBDIR)

clean:
	$(RM) -fr obj zcc_opt.def *.err
