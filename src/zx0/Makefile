
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

CFLAGS ?= -g -O2 -MMD

INSTALL ?= install

OBJS = compress.o  optimize.o  zx0.o memory.o
DEPENDS := $(OBJS:.o=.d)


all: z88dk-zx0$(EXESUFFIX) z88dk-dzx0$(EXESUFFIX)

z88dk-zx0$(EXESUFFIX):	$(OBJS)
	$(CC) -o z88dk-zx0$(EXESUFFIX) $(LDFLAGS) $(OBJS)

z88dk-dzx0$(EXESUFFIX):	dzx0.o
	$(CC) -o z88dk-dzx0$(EXESUFFIX) $(LDFLAGS) $^

install: z88dk-zx0$(EXESUFFIX) z88dk-dzx0$(EXESUFFIX)
	$(INSTALL) z88dk-zx0$(EXESUFFIX) $(PREFIX)/bin/z88dk-zx0$(EXESUFFIX)
	$(INSTALL) z88dk-dzx0$(EXESUFFIX) $(PREFIX)/bin/z88dk-dzx0$(EXESUFFIX)

clean:
	$(RM) z88dk-zx0$(EXESUFFIX) $(OBJS)
	$(RM) z88dk-dzx0$(EXESUFFIX) dzx0.o
	$(RM) -rf Debug Release
	$(RM) $(DEPENDS)

-include $(DEPENDS)
