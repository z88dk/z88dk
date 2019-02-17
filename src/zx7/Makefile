
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

INSTALL ?= install

OBJS = compress.c  optimize.c  zx7.c


all: z88dk-zx7$(EXESUFFIX) z88dk-dzx7$(EXESUFFIX)

z88dk-zx7$(EXESUFFIX):	$(OBJS)
	$(CC) -o z88dk-zx7$(EXESUFFIX) $(LDFLAGS) $(OBJS)

z88dk-dzx7$(EXESUFFIX):	dzx7.c
	$(CC) -o z88dk-dzx7$(EXESUFFIX) $(LDFLAGS) dzx7.c

install: z88dk-zx7$(EXESUFFIX) z88dk-dzx7$(EXESUFFIX)
	$(INSTALL) z88dk-zx7$(EXESUFFIX) $(PREFIX)/bin/z88dk-zx7$(EXESUFFIX)
	$(INSTALL) z88dk-dzx7$(EXESUFFIX) $(PREFIX)/bin/z88dk-dzx7$(EXESUFFIX)

clean:
	$(RM) z88dk-zx7$(EXESUFFIX) zx7.o core$(EXESUFFIX)
	$(RM) z88dk-dzx7$(EXESUFFIX) dzx7.o
	$(RM) -rf Debug Release


#Dependencies

zx7.o: zx7.c 
