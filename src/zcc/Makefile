
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

INSTALL ?= install

INCLUDES += -I. -I../copt

CFLAGS += -DLOCAL_REGEXP

OBJS = zcc.o
REGEX_OBJS = ../copt/regex/regcomp.o  ../copt/regex/regerror.o ../copt/regex/regexec.o  ../copt/regex/regfree.o

OBJS += $(REGEX_OBJS)

all: zcc$(EXESUFFIX)

zcc$(EXESUFFIX):	$(OBJS)
	$(CC) -o zcc$(EXESUFFIX) $(CFLAGS) $(OBJS)

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $(INCLUDES) $^

install: zcc$(EXESUFFIX)
	$(INSTALL) zcc$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) zcc$(EXESUFFIX) zcc.o core
	$(RM) -rf Debug Release


#Dependencies
