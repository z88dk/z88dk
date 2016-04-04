


all: info test

info:
	@echo Building Far Malloc example..

test:
	zcc +z88 -subtype=app -vn -create-app test.c -lfarz88 -o test.bin


clean:
	$(RM) test.bin
	$(RM) zcc_opt.def *~ *.op* *.o *i *.asm *.63
