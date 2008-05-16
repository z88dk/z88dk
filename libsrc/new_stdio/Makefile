include ../Make.config

default:
	$(LIBLINKER) -xt_stdio @stdio.lst
	cp t_stdio.lib ../../lib/clibs
	zcc +zx -vn test.c -o test -create-app -lt_stdio -lndos
