
OBJS = zcc.o

all: zcc 

zcc:	$(OBJS)
	${CC} -o zcc ${CFLAGS} ${CCOPT} ${OBJS}

install:
	install zcc $(PREFIX)/bin/

clean:
	$(RM) zcc zcc.o core


#Dependencies

zcc.o: zcc.c zcc.h
