
OBJS = z80svg.o 


INSTALL ?= install

XML2CONFIG ?= xml2-config
LIBS += `$(XML2CONFIG) --libs`
CFLAGS += `$(XML2CONFIG) --cflags`


all: z88dk-z80svg$(EXESUFFIX)

z88dk-z80svg$(EXESUFFIX):	$(OBJS)
	$(CC) -o z88dk-z80svg$(EXESUFFIX) $(CFLAGS) $(OBJS) $(LIBS)

install: 
	$(INSTALL) z88dk-z80svg$(EXESUFFIX) $(PREFIX)/bin/z88dk-z80svg$(EXESUFFIX)

clean:
	$(RM) z88dk-z80svg$(EXESUFFIX) z80svg.o getopt/*.o core
	$(RM) -rf Debug Release


#Dependencies

z80svg.o: z80svg.c
