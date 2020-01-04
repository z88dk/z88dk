/*
 *	z88dk RS232 Function
 *
 *	z88 version
 *
 *	unsigned char rs232_get(char *)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 */


#include <rs232.h>


uint8_t rs232_get(uint8_t *char) __naked 
{
#asm
	INCLUDE	"target/mtx/def/mtxserial.def"

	ex	de,hl
	ld	hl,RS_ERR_NO_DATA
	in	a,(CTLRS)
	and	RSRDYR
	ret	z		;Not ready
	in	a,(DATRS)
	ld	(de),a
	ld	hl,RS_ERR_OK
	ret
#endasm
}

