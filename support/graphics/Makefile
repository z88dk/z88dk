
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

OBJS = z80svg.o 


INSTALL ?= install

XML2CONFIG ?= xml2-config
LIBS += `$(XML2CONFIG) --libs`
CFLAGS += `$(XML2CONFIG) --cflags`


all: z88dk-z80svg$(EXESUFFIX)

z88dk-z80svg$(EXESUFFIX):	$(OBJS)
	$(CC) -o z88dk-z80svg$(EXESUFFIX) $(CFLAGS) $(OBJS) $(LIBS)

install: z88dk-z80svg$(EXESUFFIX)
	$(INSTALL) z88dk-z80svg$(EXESUFFIX) $(PREFIX)/bin/z88dk-z80svg$(EXESUFFIX)

clean:
	$(RM) z88dk-z80svg$(EXESUFFIX) z80svg.o getopt/*.o core
	$(RM) -rf Debug Release


#Dependencies

z80svg.o: z80svg.c
