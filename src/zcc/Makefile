
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

INSTALL ?= install

INCLUDES += -I. -I../copt -I../common -I../../ext/uthash/src

CFLAGS += -DLOCAL_REGEXP -Wall -pedantic -g -MMD

OBJS = zcc.o
COMMON_OBJS = ../copt/regex/regcomp.o  ../copt/regex/regerror.o ../copt/regex/regexec.o  ../copt/regex/regfree.o ../common/dirname.o ../common/option.o

OBJS += $(COMMON_OBJS)

DEPENDS = $(OBJS:.o=.d)

all: zcc$(EXESUFFIX)

zcc$(EXESUFFIX):	$(OBJS)
	$(CC) -o zcc$(EXESUFFIX) $(CFLAGS) $(OBJS)

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $(INCLUDES) $<

install: zcc$(EXESUFFIX)
	$(INSTALL) zcc$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) zcc$(EXESUFFIX) zcc.o core
	$(RM) $(OBJS) $(DEPENDS)
	$(RM) -rf Debug Release


#Dependencies
-include $(DEPENDS)
