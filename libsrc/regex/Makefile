
include ../Make.config

CFILES = regexp.c regsub.c regerror.c

AFILES  = $(CFILES:.c=.opt)
OBJECTS = $(CFILES:.c=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS)) $(addprefix obj/8080/,$(OBJECTS)) $(addprefix obj/gbz80/,$(OBJECTS)) $(addprefix obj/z80n/,$(OBJECTS))


dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy obj/8080 obj/gbz80 obj/z80n

clean:
	$(RM) *.err *.sym *.map zcc_opt.def *.i $(AFILES)
	$(RM) -fr obj
