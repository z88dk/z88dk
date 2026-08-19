
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

INSTALL ?= install

CFLAGS += -std=gnu99 -Wall -pedantic

OBJS = zccmulti.o

all: z88dk-zcc-multi$(EXESUFFIX)

z88dk-zcc-multi$(EXESUFFIX): $(OBJS)
	$(CC) -o z88dk-zcc-multi$(EXESUFFIX) $(LDFLAGS) $(OBJS)

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $<

install: z88dk-zcc-multi$(EXESUFFIX)
	$(INSTALL) z88dk-zcc-multi$(EXESUFFIX) $(PREFIX)/bin/z88dk-zcc-multi$(EXESUFFIX)

clean:
	$(RM) z88dk-zcc-multi$(EXESUFFIX) $(OBJS)
	$(RM) -rf Debug Release

.PHONY: all install clean
