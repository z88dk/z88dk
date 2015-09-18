##############################################################################

CC=gcc
OBJECTS=getopt.o
BINARIES=test


##############################################################################
# PHONIES

all: test

clean:
	rm -f $(BINARIES) *.o


##############################################################################
# FILES

test: test.o $(OBJECTS)
	$(CC) $(LDFLAGS) test.o $(OBJECTS) -o $@ $(LDLIBS)

test.o: test.c
	$(CC) $(CFLAGS) $< -o $@ -c

getopt.o: getopt.c
	$(CC) $(CFLAGS) $< -o $@ -c

