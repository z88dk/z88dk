#-----------------------------------------------------------------------------
# Test common utils
# Copyright (C) Paulo Custodio, 2011-2018
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------
ifeq ($(OS),Windows_NT)
  EXE	:= .exe
else
  EXE 	:= $(EXESUFFIX)
endif

CC			?= gcc
CFLAGS		+= -Wall -std=gnu11 -MMD -I../../ext/uthash/src

SRCS 		:= \
$(wildcard *.c) \
$(wildcard t/*.c) \
$(wildcard ../../ext/regex/reg*.c) \
$(wildcard ../../ext/Unity/src/*.c)

OBJS		:= $(SRCS:.c=.o)

# -DUNITY_EXCLUDE_SETJMP_H for compilation in Linux
CFLAGS		+= -DUNITY_EXCLUDE_SETJMP_H -I. -I../../ext/Unity/src

DEPENDS		:= $(SRCS:.c=.d)

all: t/test$(EXE)

t/test$(EXE): $(OBJS)
	$(CC) $(CFLAGS) -o t/test$(EXE) $(OBJS) $(LDFLAGS)

test: t/test$(EXE)
	t/test$(EXE)

clean:
	$(RM) t/test$(EXE) $(OBJS) $(DEPENDS)

-include $(DEPENDS)
