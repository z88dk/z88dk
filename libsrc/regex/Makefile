
include ../Make.config

CFILES = regexp.c regsub.c regerror.c

AFILES  = $(CFILES:.c=.opt)
OBJECTS = $(CFILES:.c=.o)

all: dirs $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS))


dirs:
	@mkdir -p obj/z80 obj/r2k


obj/z80/%.o: %.c
	zcc +test $(CFLAGS) -o $@ -c $^

obj/r2k/%.o: %.c
	zcc +rcmx000 $(CFLAGS) -o $@ -c $^

clean:
	$(RM) *.err *.sym *.map zcc_opt.def *.i $(AFILES)
	$(RM) $(addprefix obj/z80/, $(OBJECTS)) $(addprefix obj/r2k/,$(OBJECTS))
	$(RM) -fr obj
