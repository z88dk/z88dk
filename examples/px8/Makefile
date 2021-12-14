EMUL_DIR = ~/emul

adcvrt: ADCVRT.ROM

ADCVRT.ROM: adcvrt.c
	zcc +cpm -subtype=px8 -create-app -oadcvrt adcvrt.c

adcvrt.com: adcvrt.c
	zcc +cpm -subtype=px8 -oadcvrt.com adcvrt.c

run: ADCVRT.ROM
	cp ADCVRT.ROM $(EMUL_DIR)/BASIC.ROM
	wine $(EMUL_DIR)/px8.exe

clean:
	rm *.com
	rm *.ROM

ALL: adcvrt
