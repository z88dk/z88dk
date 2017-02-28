
OBJS = zcc.o
REGEX_OBJS = ../copt/regex/regcomp.o  ../copt/regex/regerror.o ../copt/regex/regexec.o  ../copt/regex/regfree.o

CFLAGS += -g -DLOCAL_REGEXP

INSTALL ?= install

all: zcc$(EXESUFFIX)

zcc$(EXESUFFIX):	$(OBJS) $(REGEX_OBJS)
	${CC} -o zcc$(EXESUFFIX) ${CFLAGS} ${CCOPT} ${OBJS} ${REGEX_OBJS}

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $(INCLUDES) $^

install:
	$(INSTALL) zcc$(EXESUFFIX) $(PREFIX)/bin/

clean:
	$(RM) zcc$(EXESUFFIX) zcc.o core
	$(RM) -rf Debug Release


#Dependencies

zcc.o: zcc.c zcc.h
