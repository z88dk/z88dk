

all: MoggyMaster.sms MoggyMaster_newlib.sms

SRCS = src/*.c

MoggyMaster.sms: bank2.o bank3.o zpragma.inc src/wtf.c
	zcc +sms src/wtf.c bank2.o bank3.o -o MoggyMaster -pragma-include:zpragma.inc -create-app -m --smslib

MoggyMaster_newlib.sms: bank2.o bank3.o zpragma.inc src/wtf.c
	zcc +sms -startup=16 -clib=new -O3 src/wtf.c bank2.o bank3.o -o MoggyMaster_newlib  -pragma-include:zpragma.inc -create-app -m

# The banks are just data so we can share between classic nad newlib
bank2.o: src/bank2.c
	zcc +sms -c --constsegBANK_02 src/bank2.c -o ./bank2.o
	
bank3.o: src/bank3.c
	zcc +sms -c --constsegBANK_03 src/bank3.c -o ./bank3.o

clean:
	$(RM) *.sms *.o *.map *.bin MoggyMaster*
