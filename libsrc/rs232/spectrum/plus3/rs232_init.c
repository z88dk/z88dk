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
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_init()
{
#asm
	ld	hl,RS_ERR_OK
#endasm
}
