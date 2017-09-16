
OBJS = lstmanip.o

INSTALL ?= install

ifeq ($(EXEPREFIX),.exe)
OBJS += ../z80nm/getopt/getopt.o
CFLAGS += -I../z80nm/getopt
endif

all: z88dk-lstmanip$(EXESUFFIX)

z88dk-lstmanip$(EXESUFFIX):	$(OBJS)
	$(CC) -o $@ $(CFLAGS) $(OBJS)

install: 
	$(INSTALL) z88dk-lstmanip$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)z80nm$(EXESUFFIX)

clean:
	$(RM) z88dk-lstmanip$(EXESUFFIX) lstmanip.o core
	$(RM) -rf Debug Release


#Dependencies

lstmanip.o: lstmanip.c
