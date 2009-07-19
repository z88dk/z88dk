
OBJS = zcc.o

all: zcc$(EXESUFFIX)

zcc$(EXESUFFIX):	$(OBJS)
	${CC} -o zcc$(EXESUFFIX) ${CFLAGS} ${CCOPT} ${OBJS}

install:
	install zcc$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) zcc$(EXESUFFIX) zcc.o core


#Dependencies

zcc.o: zcc.c zcc.h
