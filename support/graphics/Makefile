
OBJS = z80svg.o 

INSTALL ?= install
CFLAGS += `pkg-config libxml-2.0 --cflags`
LIBS += `pkg-config libxml-2.0 --libs`


all: z80svg$(EXESUFFIX)

z80svg$(EXESUFFIX):	$(OBJS)
	$(CC) -o z80svg$(EXESUFFIX) $(CFLAGS) $(CCOPT) $(OBJS) $(LIBS)

install: 
	$(INSTALL) z80svg$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) z80svg$(EXESUFFIX) z80svg.o getopt/*.o core
	$(RM) -rf Debug Release


#Dependencies

z80svg.o: z80svg.c
