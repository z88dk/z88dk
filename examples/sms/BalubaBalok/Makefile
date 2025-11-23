

all: BalubaBalok.sms BalubaBalok_newlib.sms

SRCS = src/*.c

BalubaBalok.sms: bank1.o  zpragma.inc src/game.c
	zcc +sms src/game.c bank1.o -o BalubaBalok -pragma-include:zpragma.inc -create-app -m --smslib

BalubaBalok_newlib.sms: bank1.o  zpragma.inc src/game.c
	zcc +sms -startup=16 -clib=new src/game.c bank1.o -o BalubaBalok_newlib  -pragma-include:zpragma.inc -create-app -m

# The banks are just data so we can share between classic nad newlib
bank1.o: src/bank1.c
	zcc +sms -c src/bank1.c -o ./bank1.o
	
clean:
	$(RM) *.sms *.o *.map *.bin BalubaBalok*
