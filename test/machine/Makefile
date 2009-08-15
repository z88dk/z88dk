


SOURCES = main.c Z80/Debug.c Z80/Z80.c hook_io.c hook_console.c
OBJECTS = $(SOURCES:.c=.o)
HEADERS = machine.h cmds.h

# add -DDEBUG to include the debugger
CFLAGS = -DZ88DK -DJUMPZ80  -DDEBUG2 -DLSB_FIRST


all: machine$(EXESUFFIX)


%.o: %.c $(HEADERS)
	$(CC) -c -o $@ $(CFLAGS) $<

machine$(EXESUFFIX): $(OBJECTS)
	$(CC) -o $@ $(OBJECTS)


clean:
	rm -f $(OBJECTS) machine$(EXESUFFIX) *~
