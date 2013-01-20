
OBJS = ar.o 

ifeq ($(EXEPREFIX),.exe)
OBJS += getopt/getopt.o
CFLAGS += -Igetopt
endif

all: z80nm$(EXESUFFIX)

z80nm$(EXESUFFIX):	$(OBJS)
	${CC} -o z80nm$(EXESUFFIX) ${CFLAGS} ${CCOPT} ${OBJS}

install: 
	install z80nm$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) z80nm$(EXESUFFIX) ar.o getopt/*.o core
	$(RM) -rf Debug Release


#Dependencies

ar.o: ar.c
