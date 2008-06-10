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
 *      $Id: rs232_init.c,v 1.2 2008-06-10 07:59:10 stefano Exp $
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_init()
{
#asm
	ld	hl,RS_ERR_OK
#endasm
}
