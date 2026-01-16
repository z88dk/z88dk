/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum +3 version
 *
 *	unsigned char rs232_init()
 *
 *	Initialise the serial interface
 *
 *	Still nothing, here!
 *
 *      $Id: rs232_init.c,v 1.5 2015-01-21 08:27:13 stefano Exp $
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_init()
{
#asm
	ld	hl,RS_ERR_OK
	ret

	PUBLIC BAUD
	PUBLIC SERFL

	BAUD:
		; Default speed: 2400 baud 
		defw 54
SERFL:
		; flag + data byte about an eventual 2nd character already transmitted
		defw 0
#endasm
}
