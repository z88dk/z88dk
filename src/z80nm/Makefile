#------------------------------------------------------------------------------
# z88dk z80nm Makefile
#------------------------------------------------------------------------------

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

include ../Make.common

SRCS 		:= $(wildcard *.c) \
			../z80asm/zutils.c \
			../common/die.c \
			../common/objfile.c \
			../common/fileutil.c \
			../common/strutil.c \
$(wildcard ../../ext/regex/reg*.c)

OBJS	:= $(SRCS:.c=.o) \
			$(UNIXem_OBJS)

DEPENDS	:= $(SRCS:.c=.d)

OPT 	:= -O3
#OPT 	:= -O3 -pg

CFLAGS += $(OPT) -Wall -std=gnu11 -MMD -std=gnu11 -I../common -I../../ext/uthash/src -I../../ext/regex -I../z80asm \
			$(UNIXem_CFLAGS)

INSTALL ?= install

# Use these flags both in Windows_NT and in a MinGW build in Unix
ifeq ($(EXESUFFIX),.exe)
CFLAGS	+= \
-I../../ext/getopt 
OBJS	+= \
../../ext/getopt/getopt.o
endif

all: z80nm$(EXESUFFIX)

z80nm$(EXESUFFIX):	$(OBJS)
	$(CC) -o z80nm$(EXESUFFIX) $(CFLAGS) $(OBJS)

install:  z80nm$(EXESUFFIX)
	$(INSTALL) z80nm$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)z80nm$(EXESUFFIX)

clean:
	$(RM) z80nm$(EXESUFFIX) $(OBJS) $(DEPENDS) core
	$(RM) -rf Debug Release


#Dependencies

ar.o: ar.c

-include $(DEPENDS)
