
OBJS = z80svg.o 


INSTALL ?= install

XML2CONFIG ?= xml2-config
LIBS += `$(XML2CONFIG) --libs`
CFLAGS += `$(XML2CONFIG) --cflags`


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
