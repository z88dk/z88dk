#

include ../../Make.config

vpath %.c ../../_DEVELOPMENT/math/float/math32/c
vpath %.c ../cimpl


CFILES  = $(notdir $(wildcard ../../_DEVELOPMENT/math/float/math32/c/*.c)) atof.c ftoa.c ftoe.c
CFILES  = atof.c ftoa.c ftoe.c ftoa_fudgeit.c
OBJECTS = $(CFILES:.c=.o)

CFLAGS += -fp-mode=ieee  -DMUST_ROUND

all: dirs $(OUTPUT_DIRECTORY)/math32.lib $(OUTPUT_DIRECTORY)/math32_fast.lib \
	$(OUTPUT_DIRECTORY)/math32_ixiy.lib $(OUTPUT_DIRECTORY)/math32_z80n.lib $(OUTPUT_DIRECTORY)/math32_z180.lib


$(OUTPUT_DIRECTORY)/math32.lib: $(addprefix obj/z80/, $(OBJECTS))
	@echo "DEFC __CLIB_OPT_FMATH = 50" > config_private.inc
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80/x/x  -I.. -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32 @math32.lst

$(OUTPUT_DIRECTORY)/math32_fast.lib: $(addprefix obj/z80-fast/, $(OBJECTS))
	@echo "DEFC __CLIB_OPT_FMATH = 100" > config_private.inc
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80-fast/x/x -I.. -mz80 -D__CLASSIC  @newlibfiles_z80.lst
	TYPE=z80-fast $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32_fast @math32.lst

$(OUTPUT_DIRECTORY)/math32_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	@echo "DEFC __CLIB_OPT_FMATH = 50" > config_private.inc
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ixiy/x/x -I.. --IXIY -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ixiy $(LIBLINKER) --IXIY -x$(OUTPUT_DIRECTORY)/math32_ixiy @math32.lst

$(OUTPUT_DIRECTORY)/math32_z80n.lib: $(addprefix obj/z80n/, $(OBJECTS))
	@echo "DEFC __CLIB_OPT_FMATH = 50" > config_private.inc
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80n/x/x -I.. -mz80n -D__CLASSIC @newlibfiles_z80n.lst
	TYPE=z80n $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32_z80n @math32.lst

$(OUTPUT_DIRECTORY)/math32_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	@echo "DEFC __CLIB_OPT_FMATH = 50" > config_private.inc
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z180/x/x -I.. -mz180 -D__CLASSIC @newlibfiles_z180.lst
	TYPE=z180 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32_z180 @math32.lst

obj/z80-fast/%.o: %.c
	$(ZCC) +test -mz80 $(CFLAGS) -o $@  $^

dirs:
	@mkdir -p obj/z80/c obj/z180/c obj/z80n/c obj/ixiy/c obj/z80-fast/c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt config_private.inc
	$(RM) -fr obj

