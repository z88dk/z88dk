
install_to = /usr/local

all: copt

copt: copt.c
	${CC} -o ../../bin/copt ${CFLAGS} ${CCOPTS} -DUSE_REGEXP copt.c

install: ../../bin/copt copt.1
	install ../../bin/copt $(install_to)/bin/
	install copt.1 $(install_to)/man/man1

