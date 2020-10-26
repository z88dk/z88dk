/*
 *	z88dk RS232 Function
 *
 *	uint8_t rs232_put(uint8_t)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 */


#include <rs232.h>


uint8_t rs232_put(uint8_t char) __naked __z88dk_fastcall
{
#asm
	ld	a,l
        rst     8
	ld	hl,RS_ERR_OK
	ret
#endasm
}

