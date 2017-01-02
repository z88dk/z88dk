
all: test.bin libctest.bin pongmstr.bin pngmstr2.bin apktest.bin chicken.bin testsnd.bin

test.bin: test.c
	zcc +sms test.c -o test.bin -m
	echo test.map test.sym
	
libctest.bin: libctest.c
	zcc +sms libctest.c -o libctest.bin -m
	echo libctest.map libctest.sym

pong_graphics.o: pong_graphics.asm batnball.til numbers.til bkg.til icons.til
	z80asm -d pong_graphics.asm

testtxt_apk.o: testtxt_apk.asm testtxt.apk
	z80asm -d testtxt_apk.asm

pongmstr.bin: pong_graphics.o pongmstr.c
	zcc +sms pong_graphics.o pongmstr.c -o pongmstr.bin -m -create-app
	echo pongmstr.map pongmstr.sym

pngmstr2.bin: pong_graphics.o pngmstr2.c
	zcc +sms pong_graphics.o pngmstr2.c -o pngmstr2.bin -m -create-app
	echo pngmstr2.map pngmstr2.sym

apktest.bin: testtxt_apk.o apktest.c
	zcc +sms testtxt_apk.o apktest.c -o apktest.bin -m -create-app
	echo apktest.map apktest.sym

chicken_graphics.o: chicken_graphics.asm road.til sidewalk.til car1.til
	z80asm -d chicken_graphics.asm

chicken.bin: chicken_graphics.o chicken.c
	zcc +sms chicken_graphics.o chicken.c -o chicken.bin -m -create-app
	echo chicken.map chicken.sym

testsnd.bin: testsnd.c
	zcc +sms testsnd.c -o testsnd.bin -m -create-app
	echo testsnd.map testsnd.sym

clean:
	$(RM) *.bin *.i *.lib *.op* *.o *~ zcc_opt.def
