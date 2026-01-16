#include <arch/sms/SMSlib.h>
#include "vdp.h"

void VDP_printText(char *text, unsigned char x, unsigned char y, unsigned int baseTile)
{
	char *currentChar;
	SMS_setNextTileatXY(x,y);
	currentChar = text;
	while(*currentChar != 0)
	{
		SMS_setTile(baseTile + *currentChar -32);
		currentChar++;
	}
	
}

void VDP_clearBG()
{
	//32*24 chars, using 2bytes
	SMS_VRAMmemset(SMS_PNTAddress, 0, 32*28*2);
	//TODO : GG version ?
}
