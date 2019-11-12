#------------------------------------------------------------------------------
# z80asm restart
# Copyright (C) Paulo Custodio, 2011-2019
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------
PROJ			:= z80asm2

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 	:= .exe
else
  EXESUFFIX 	?=
endif

CC 				?= gcc
INSTALL 		?= install
CROSS			?= 0

SRCS			:= $(filter-out test.c,$(wildcard *.c))
OBJS 			:= $(SRCS:.c=.o)
DEPENDS			:= $(SRCS:.c=.d)

TARGET 			= $(PROJ)$(EXESUFFIX)

OPT 			= -O3

STD 			= -std=gnu11
LOCAL_CFLAGS 	+= -MMD -g -Wall $(STD) $(OPT)

.PHONY: all

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

%.o: %.c
	$(CC) $(LOCAL_CFLAGS) $(CFLAGS) -c -o $@ $<

clean::
	$(RM) *.core *.o *.out *.orig *.exe *.tmp *.bak *.log *~ test.* $(OBJS) $(DEPENDS)

-include $(DEPENDS)

.PHONY: test

test: $(TARGET)
	perl -S prove t/*.t
