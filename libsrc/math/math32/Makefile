#

include ../../Make.config

vpath %.c ../../_DEVELOPMENT/math/float/math32/c

CFILES  = $(notdir $(wildcard ../../_DEVELOPMENT/math/float/math32/c/*.c))
OBJECTS = $(CFILES:.c=.o)

CFLAGS += -fp-mode=ieee -I../../_DEVELOPMENT/math/float/math32/c/

all: dirs $(OUTPUT_DIRECTORY)/math32.lib 


$(OUTPUT_DIRECTORY)/math32.lib: $(addprefix obj/z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -O=obj/z80/x/x -I.. -mz80 -D__CLASSIC @newlibfiles.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32 @math32.lst

dirs:
	@mkdir -p obj/z80/c obj/z180/c obj/z80-zxn/c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

