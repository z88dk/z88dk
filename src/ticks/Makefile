
OBJS = ticks.o hook_console.o hook_io.o hook_misc.o hook.o

CFLAGS += -g

INSTALL ?= install

all: ticks$(EXESUFFIX)

ticks$(EXESUFFIX):	$(OBJS)
	${CC} -o ticks$(EXESUFFIX) ${CFLAGS} ${CCOPT} ${OBJS}

install:
	$(INSTALL) ticks$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) ticks$(EXESUFFIX) $(OBJS) core
	$(RM) -rf Debug Release


