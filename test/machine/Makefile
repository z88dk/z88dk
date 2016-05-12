

SOURCES_COMMON = main.c Z80/Debug.c hook_io.c hook_console.c hook_misc.c
SOURCES_Z80 = Z80/Z80.c
OBJECTS = $(SOURCES_COMMON:.c=.o) Z80/Z80.o
OBJECTS_RCMX = $(SOURCES_COMMON:.c=.o) Z80/Z80_rcmx.o Z80/rcmx_io.o
HEADERS = machine.h cmds.h

# add -DDEBUG to include the debugger
CFLAGS = -DZ88DK -DJUMPZ80  -DDEBUG -DLSB_FIRST


all: free machine$(EXESUFFIX) machine_rcmx$(EXESUFFIX)


%.o: %.c $(HEADERS)
	$(CC) -g -c -o $@ $(CFLAGS) $<

Z80/Z80_rcmx.o: Z80/Z80.c
	$(CC) -DRCMX000 -g -c -o $@ $(CFLAGS) $<

machine$(EXESUFFIX): $(OBJECTS)
	$(CC) -o $@ $(OBJECTS)

machine_rcmx$(EXESUFFIX): $(OBJECTS_RCMX)
	$(CC) -o $@ $(OBJECTS_RCMX)


clean: free-clean
	rm -f $(OBJECTS) $(OBJECTS_RCMX) machine$(EXESUFFIX) machine_rcmx$(EXESUFFIX) *~ patch fetch Z80-081707.zip extract

# Target for GPL compatible distribution
free: fetch extract patch

Z80-081707.zip:
	wget http://fms.komkon.org/EMUL8/Z80-081707.zip

fetch:  Z80-081707.zip
	@touch fetch

extract:
	unzip -a Z80-081707.zip
	@touch extract

patch:
	cd Z80 ; patch -p1 < ../rcm.patch
	@touch patch


free-clean:
	rm -f Z80/Codes.h Z80/CodesED.h	Z80/CodesXX.h Z80/Debug.c Z80/Z80.c Z80/CodesCB.h Z80/CodesXCB.h Z80/ConDebug.c	Z80/Tables.h	Z80/Z80.h


