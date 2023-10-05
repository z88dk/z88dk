
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

OBJS = z80svg.o 


INSTALL ?= install


ifeq ($(CROSS),1)
   LIBS += `pkg-config     --define-prefix --libs libxml-2.0`
   CFLAGS += `pkg-config     --define-prefix --cflags libxml-2.0`
else
   LIBS += `pkg-config    --libs libxml-2.0`
   CFLAGS += `pkg-config  --cflags libxml-2.0`
endif

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
