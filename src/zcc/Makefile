
ZCCOBJS = zcc.c
CC = gcc

CCOPT = -DUNIX

all: zcc 

zcc:
	${CC} -o ../../bin/zcc ${CFLAGS} ${CCOPT} ${ZCCOBJS}

install:
	install ../../bin/zcc $(PREFIX)/bin


#Dependencies

zcc.o: zcc.c zcc.h
