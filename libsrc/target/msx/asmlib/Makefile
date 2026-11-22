

include ../../../Make.config


TARGET ?= msx


CFILES = $(wildcard *.c)
ASMFILES = $(wildcard *.asm)

OBJECTS = $(CFILES:.c=.o) $(ASMFILES:.asm=.o)

all: $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS))

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	@$(ASSEMBLER) $(ASMFLAGS) -I.. -Oobj/$(OBJSUBDIR) $^

# Order-only: dirs must finish before any object compiles. See Make.config.
$(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)): | dirs

dirs:
	$(Q)mkdir -p obj/$(OBJSUBDIR)

clean:
	$(RM) -fr obj zcc_opt.def *.err
