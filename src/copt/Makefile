

all: copt

copt: copt.c
	${CC} -o ../../bin/copt ${CFLAGS} ${CCOPTS} -DUSE_REGEXP copt.c

install: ../../bin/copt copt.1
	install ../../bin/copt $(PREFIX)/bin
	install -m 644 copt.1 $(PREFIX)/man/man1

