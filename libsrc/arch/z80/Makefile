

include ../../Make.config


CFILES = $(wildcard *.c)
OBJECTS = $(CFILES:.c=.o)

DESTDIR=$(OUTPUT_DIRECTORY)/

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/z80/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/z80/z80/*.asm"
NEWLIB_TARGETS := obj/newlib-z80 obj/newlib-z80n 


all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

%.o: %.c
	$(ZCC) +test $(CFLAGS) -c $^

obj/newlib-z80:
	@$(ASSEMBLER) -d -O=obj/z80/x -I../.. -mz80 -D__CLASSIC $(NEWLIBGLOBS)

obj/newlib-z80n:
	@$(ASSEMBLER) -d -O=obj/z80n/x -I../.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)


dirs:
	mkdir -p obj

clean:
	$(RM) -f *.o zcc_opt.def
	$(RM) -fr obj




