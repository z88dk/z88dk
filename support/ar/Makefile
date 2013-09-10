
OBJS = ar.o 

INSTALL ?= install

ifeq ($(EXEPREFIX),.exe)
OBJS += getopt/getopt.o
CFLAGS += -Igetopt
endif

all: z80nm$(EXESUFFIX)

z80nm$(EXESUFFIX):	$(OBJS)
	${CC} -o z80nm$(EXESUFFIX) ${CFLAGS} ${CCOPT} ${OBJS}

install: 
	$(INSTALL) z80nm$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) z80nm$(EXESUFFIX) ar.o getopt/*.o core
	$(RM) -rf Debug Release


#Dependencies

ar.o: ar.c
