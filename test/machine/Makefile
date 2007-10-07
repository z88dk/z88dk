


SOURCES = main.c Z80/Debug.c Z80/Z80.c
OBJECTS = $(SOURCES:.c=.o)
HEADERS = 

CFLAGS = -DZ88DK -DJUMPZ80  -DDEBUG2 -DLSB_FIRST


all: machine


%.o: %.c $(HEADERS)
	gcc -c -o $@ $(CFLAGS) $<

machine: $(OBJECTS)
	gcc -o $@ $(OBJECTS)


clean:
	rm -f $(OBJECTS) machine *~
