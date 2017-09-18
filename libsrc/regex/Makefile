
include ../Make.config

CFILES = regexp.c regsub.c regerror.c

AFILES  = $(CFILES:.c=.opt)
OBJECTS = $(CFILES:.c=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS)) $(addprefix obj/ixiy/,$(OBJECTS))


dirs:
	@mkdir -p obj/z80 obj/r2k obj/ixiy

clean:
	$(RM) *.err *.sym *.map zcc_opt.def *.i $(AFILES)
	$(RM) $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS))
	$(RM) -fr obj
