#

include ../../Make.config

AFILES  = $(wildcard c/sccz80/*.asm)
CFILES  = $(wildcard *.c)
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS += -fp-mode=mbf32

all: dirs $(OUTPUT_DIRECTORY)/mbf32.lib $(OUTPUT_DIRECTORY)/mbf32_iy.lib 


$(OUTPUT_DIRECTORY)/mbf32.lib: $(addprefix obj/z80/, $(OBJECTS))
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/mbf32 @mbf32.lst

$(OUTPUT_DIRECTORY)/mbf32_iy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	TYPE=ixiy $(LIBLINKER) --IXIY -x$(OUTPUT_DIRECTORY)/mbf32_iy @mbf32.lst

dirs:
	@mkdir -p obj/z80/c/sccz80 obj/ixiy/c/sccz80

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

