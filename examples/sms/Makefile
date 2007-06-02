
all: test.sms libctest.sms pongmstr.sms pngmstr2.sms apktest.sms chicken.sms testsnd.sms

test.sms: test.c
	zcc +sms test.c -o test.sms -m
	echo test.map test.sym
	
libctest.sms: libctest.c
	zcc +sms libctest.c -o libctest.sms -m
	echo libctest.map libctest.sym

pong_graphics.o: pong_graphics.asm batnball.til numbers.til bkg.til icons.til
	z80asm -d -ns -nm -Mo pong_graphics.asm

testtxt_apk.o: testtxt_apk.asm testtxt.apk
	z80asm -d -ns -nm -Mo testtxt_apk.asm

pongmstr.sms: pong_graphics.o pongmstr.c
	zcc +sms pong_graphics.o pongmstr.c -o pongmstr.sms -m -create-app
	echo pongmstr.map pongmstr.sym

pngmstr2.sms: pong_graphics.o pngmstr2.c
	zcc +sms pong_graphics.o pngmstr2.c -o pngmstr2.sms -m -create-app
	echo pngmstr2.map pngmstr2.sym

apktest.sms: testtxt_apk.o apktest.c
	zcc +sms testtxt_apk.o apktest.c -o apktest.sms -m -create-app
	echo apktest.map apktest.sym

chicken_graphics.o: chicken_graphics.asm road.til sidewalk.til car1.til
	z80asm -d -ns -nm -Mo chicken_graphics.asm

chicken.sms: chicken_graphics.o chicken.c
	zcc +sms chicken_graphics.o chicken.c -o chicken.sms -m -create-app
	echo chicken.map chicken.sym

testsnd.sms: testsnd.c
	zcc +sms testsnd.c -o testsnd.sms -m -create-app
	echo testsnd.map testsnd.sym

clean:
	$(RM) *.bin *.i *.lib *.op* *.o *~ zcc_opt.def
