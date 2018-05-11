ifeq ($(OS),Windows_NT)
  EXE 		:= .exe
else
  EXE 		:= $(EXESUFFIX)
endif

SRCS 		:= $(wildcard *.c) \
../common/die.c \
../common/objfile.c \
../common/fileutil.c \
../common/strutil.c \
$(wildcard ../../ext/regex/reg*.c)

OBJS	:= $(SRCS:.c=.o)

DEPENDS	:= $(SRCS:.c=.d)

CFLAGS += -Wall -std=gnu11 -MMD -std=gnu11 -I../common -I../../ext/uthash/src -I../../ext/regex

INSTALL ?= install

# Use these flags both in Windows_NT and in a MinGW build in Unix
ifeq ($(EXE),.exe)
CFLAGS	+= \
-I../../ext/UNIXem/include \
-I../../ext/getopt 
OBJS	+= \
../../ext/UNIXem/src/glob.o \
../../ext/UNIXem/src/dirent.o \
../../ext/getopt/getopt.o
endif

all: z80nm$(EXESUFFIX)

z80nm$(EXESUFFIX):	$(OBJS)
	$(CC) -o z80nm$(EXESUFFIX) $(CFLAGS) $(OBJS)

install: 
	$(INSTALL) z80nm$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)z80nm$(EXESUFFIX)

clean:
	$(RM) z80nm$(EXESUFFIX) $(OBJS) $(DEPENDS) core
	$(RM) -rf Debug Release


#Dependencies

ar.o: ar.c

-include $(DEPENDS)
