include ../Make.config

default:
	$(LIBLINKER) -x../$(OUTPUT_DIRECTORY)/stdio @stdio.lst

test:	test/test.c stdio.lib
	zcc +zx -vn test/test.c -o test/test -lstdio -create-app -lndos
