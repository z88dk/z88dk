include ../Make.config

default:
	$(LIBLINKER) -xstdio @stdio.lst
	cp stdio.lib ../../lib/clibs

test:	test/test.c stdio.lib
	zcc +zx -vn test/test.c -o test/test -lstdio -create-app -lndos
