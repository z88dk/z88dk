SRCS 		:= $(wildcard *.c) \
../common/die.c \
../common/objfile.c \
$(wildcard ../../ext/regex/reg*.c)

OBJS	:= $(SRCS:.c=.o)

DEPENDS	:= $(SRCS:.c=.d)

CFLAGS += -Wall -std=gnu11 -MMD -std=gnu11 -I../common -I../../ext/uthash/src -I../../ext/regex

INSTALL ?= install

ifeq ($(EXEPREFIX),.exe)
OBJS += ../../ext/getopt/getopt.o
CFLAGS += -I../../ext/getopt 
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
