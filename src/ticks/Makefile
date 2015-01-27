
OBJS = ticks.o

CFLAGS += -g

INSTALL ?= install

all: ticks$(EXESUFFIX)

ticks$(EXESUFFIX):	$(OBJS)
	${CC} -o ticks$(EXESUFFIX) ${CFLAGS} ${CCOPT} ${OBJS}

install:
	$(INSTALL) ticks$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) ticks$(EXESUFFIX) ticks.o core
	$(RM) -rf Debug Release


#Dependencies

ticks.o: ticks.c 
