/*
 *	z88dk RS232 Function
 *
 *	uint8_t rs232_put(uint8_t)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 */


#include <rs232.h>


uint8_t rs232_put(uint8_t char) __naked
{
#asm
	INCLUDE	"target/mtx/def/mtxserial.def"

wait_for_ready:
	in	a,(CTLRS)	
	and	RSRDYW
	jr	z,wait_for_ready
	ld	a,l
	out	(DATRS),a
	ld	hl,RS_ERR_OK
	ret
#endasm
}

