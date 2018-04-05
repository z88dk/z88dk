
OBJS = ar.o ../common/die.o
CFLAGS += -std=gnu11 -I../common -I../../ext/uthash/src

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
	$(RM) z80nm$(EXESUFFIX) $(OBJS) core
	$(RM) -rf Debug Release


#Dependencies

ar.o: ar.c
