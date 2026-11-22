# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

CFLAGS ?= -g -O2 -MMD

INSTALL ?= install

all: z88dk-asm7801$(EXESUFFIX)

z88dk-asm7801$(EXESUFFIX): asm7801.c asm7801_ops.h
	$(CC) $(CFLAGS) -o z88dk-asm7801$(EXESUFFIX) $(LDFLAGS) asm7801.c

install: z88dk-asm7801$(EXESUFFIX)
	$(INSTALL) z88dk-asm7801$(EXESUFFIX) $(PREFIX)/bin/z88dk-asm7801$(EXESUFFIX)

clean:
	$(RM) z88dk-asm7801$(EXESUFFIX) *.d

-include *.d
