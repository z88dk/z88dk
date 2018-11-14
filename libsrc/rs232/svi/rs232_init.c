/*
 *	z88dk RS232 Function
 *
 *	z88 version
 *
 *	unsigned char rs232_init()
 *
 *	Initialise the serial interface
 */


#include <rs232.h>


uint8_t __FASTCALL__ rs232_init() __naked
{
#asm
	ld	hl,RS_ERR_OK
	ret
#endasm
}
