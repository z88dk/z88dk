
OBJS = zcc.o

CFLAGS += -g

INSTALL ?= install

all: zcc$(EXESUFFIX)

zcc$(EXESUFFIX):	$(OBJS)
	${CC} -o zcc$(EXESUFFIX) ${CFLAGS} ${CCOPT} ${OBJS}

install:
	$(INSTALL) zcc$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) zcc$(EXESUFFIX) zcc.o core
	$(RM) -rf Debug Release


#Dependencies

zcc.o: zcc.c zcc.h
