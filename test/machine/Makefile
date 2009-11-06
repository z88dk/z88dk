

SOURCES_COMMON = main.c Z80/Debug.c hook_io.c hook_console.c
SOURCES_Z80 = Z80/Z80.c
OBJECTS = $(SOURCES_COMMON:.c=.o) Z80/Z80.o
OBJECTS_RCMX = $(SOURCES_COMMON:.c=.o) Z80/Z80_rcmx.o Z80/rcmx_io.o
HEADERS = machine.h cmds.h

# add -DDEBUG to include the debugger
CFLAGS = -DZ88DK -DJUMPZ80  -DDEBUG -DLSB_FIRST


all: machine$(EXESUFFIX) machine_rcmx$(EXESUFFIX)


%.o: %.c $(HEADERS)
	$(CC) -g -c -o $@ $(CFLAGS) $<

Z80/Z80_rcmx.o: Z80/Z80.c
	$(CC) -DRCMX000 -g -c -o $@ $(CFLAGS) $<

machine$(EXESUFFIX): $(OBJECTS)
	$(CC) -o $@ $(OBJECTS)

machine_rcmx$(EXESUFFIX): $(OBJECTS_RCMX)
	$(CC) -o $@ $(OBJECTS_RCMX)


clean:
	rm -f $(OBJECTS) $(OBJECTS_RCMX) machine$(EXESUFFIX) machine_rcmx$(EXESUFFIX) *~
