# $Id: Makefile $

include ../../../Make.config

CFILES = \
	syserrlist.c   \
	initdcb.c   \
	addext.c   \
	genspec.c   \
	open.c   \
	close.c  \
	readbyte.c  \
	writebyte.c  \
	read.c  \
	write.c  \
	lseek.c  \
	creat.c  \
	remove.c

AFILES = $(CFILES:.c=.asm)
OFILES = $(CFILES:.c=.o)
OBJECTS = $(addprefix obj/,$(OFILES))

all: dirs $(OBJECTS)
	@echo ''
	@echo '---> Building TRSDOS library <---'
	@echo ''
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/trsdos @trsdos.lst
	

obj/%.o: %.c
	$(ZCC) +trs80 $(CFLAGS) $^ -o $@

dirs:
	@mkdir -p obj

clean:
	$(RM) *.sym *.map zcc_opt.def *.o* obj/*.o* $(OUTPUT_DIRECTORY)/trsdos.lib
	$(RM) -r obj
