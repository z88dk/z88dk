/*
 *	Rex findlib routine
 *
 * 	18/1/2002 - Daniel - Original
 *	27/1/2002 - djm - Optimized things slightly (unsigned chars etc)
 *
 *	$Id: findlib.c,v 1.1 2002-01-27 15:26:56 dom Exp $
 */

#include <rex/rex.h>

unsigned char pages[] = {0x16, 0x17, 0x18, 0x2B, 0x49, 0x4D, 0x58,
	0x62, 0x78, 0x79, 0x7A, 0x7C, 0x7D, 0x7E, 0x7F,
	0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
	0x88, 0x89};

extern unsigned char sig1(0xBFFD);
extern unsigned char sig2(0xBFFE);
extern unsigned char sig3(0xBFFF);

int findlib(unsigned char *s)
{
	int i;
	unsigned char s1,s2,s3;
	
	s1 = *s++;
	s2 = *s++;
	s3 = *s;

	REGISTER_WRITE(REG_BANK2_HI, 0x00);
	for(i=0; i<25; i++)
	{
		REGISTER_WRITE(REG_BANK2_LO, pages[i]);
		if(s1 == sig1 && s2 == sig2 && s3 == sig3)
			return pages[i]-4;
	}
	return -1;
}
