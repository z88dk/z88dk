
ZCCOBJS = zcc.c
CC = gcc

CCOPT = -DUNIX

all: zcc 

zcc:
	${CC} -o ../../bin/zcc ${CFLAGS} ${CCOPT} ${ZCCOBJS}


#Dependencies

zcc.o: zcc.c zcc.h
