include ../../Make.config

SUBTYPE ?= hector1

HECTOR_AFILES = $(wildcard */*.asm)

HECTOR_OBJS = $(addprefix obj/$(SUBTYPE)/,$(HECTOR_AFILES:.asm=.o))

all: dirs $(HECTOR_OBJS)


obj/$(SUBTYPE)/%.o: %.asm
	$(Q)$(ASSEMBLER) -mz80 -I$(Z88DK_LIBSRC) -I$(Z88DK_LIB) -DFOR$(SUBTYPE) $(AFLAGS) -D__CLASSIC -o=$@ $<

obj/interact/%.o: %.asm
	$(Q)$(ASSEMBLER) -m8080 -I$(Z88DK_LIBSRC) -I$(Z88DK_LIB) -DFOR$(SUBTYPE) $(AFLAGS) -D__CLASSIC -o=$@ $<

dirs:
	@mkdir -p obj/$(SUBTYPE)/stdio obj/$(SUBTYPE)/graphics

clean:
	$(RM) -fr obj
