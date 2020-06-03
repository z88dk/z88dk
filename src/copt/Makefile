
# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

INSTALL ?= install

INCLUDES += -I.

LOCAL_CFLAGS += -DLOCAL_REGEXP
OBJS = copt.o
REGEX_OBJS = regex/regcomp.o  regex/regerror.o regex/regexec.o  regex/regfree.o

CFLAGS += -std=gnu99 -Wall -pedantic

OBJS += $(REGEX_OBJS)

all: z88dk-copt$(EXESUFFIX)

z88dk-copt$(EXESUFFIX):	$(OBJS)
	$(CC) -o z88dk-copt$(EXESUFFIX) $(LDFLAGS) $(OBJS)

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $(LOCAL_CFLAGS) $(INCLUDES) $^

install: z88dk-copt$(EXESUFFIX)
	$(INSTALL) z88dk-copt$(EXESUFFIX) $(PREFIX)/bin/z88dk-copt$(EXESUFFIX)

clean:
	$(RM) z88dk-copt$(EXESUFFIX) copt.o core$(EXESUFFIX) regex/*.o
	$(RM) -rf Debug Release


#Dependencies

copt.o: copt.c 
