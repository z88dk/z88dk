
COMPILER ?= sccz80
CFLAGS = 

ifeq ($(COMPILER),sdcc)
   CFLAGS += -compiler=sdcc  -SO3 --max-allocs-per-node200000 --fsigned-char 
all: test.sms libctest.sms  apktest.sms testsnd.sms
else
all: test.sms libctest.sms pongmstr.sms pngmstr2.sms apktest.sms chicken.sms testsnd.sms
endif



test.sms: test.c
	zcc +sms $(CFLAGS) test.c -o test.bin -create-app
	echo test.map test.sym
	
libctest.sms: libctest.c
	zcc +sms $(CFLAGS) libctest.c -o libctest.bin -create-app
	echo libctest.map libctest.sym

pong_graphics.o: pong_graphics.asm batnball.til numbers.til bkg.til icons.til
	z80asm -d pong_graphics.asm

testtxt_apk.o: testtxt_apk.asm testtxt.apk
	z80asm -d testtxt_apk.asm

pongmstr.sms: pong_graphics.o pongmstr.c
	zcc +sms $(CFLAGS) pong_graphics.o pongmstr.c -o pongmstr.bin  -create-app
	echo pongmstr.map pongmstr.sym

pngmstr2.sms: pong_graphics.o pngmstr2.c
	zcc +sms $(CFLAGS) pong_graphics.o pngmstr2.c -o pngmstr2.bin  -create-app
	echo pngmstr2.map pngmstr2.sym

apktest.sms: testtxt_apk.o apktest.c
	zcc +sms $(CFLAGS) testtxt_apk.o apktest.c -o apktest.bin  -create-app
	echo apktest.map apktest.sym

chicken_graphics.o: chicken_graphics.asm road.til sidewalk.til car1.til
	z80asm -d chicken_graphics.asm

chicken.sms: chicken_graphics.o chicken.c
	zcc +sms $(CFLAGS) chicken_graphics.o chicken.c -o chicken.bin  -create-app
	echo chicken.map chicken.sym

testsnd.sms: testsnd.c
	zcc +sms $(CFLAGS) testsnd.c -o testsnd.bin  -create-app
	echo testsnd.map testsnd.sym

clean:
	$(RM) *.bin *.i *.lib *.op* *.o *~ zcc_opt.def *.sms
