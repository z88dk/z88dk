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
	INCLUDE	"target/svi/def/sviserial.def"
	EXTERN	rs232_status

	ex	de,hl
	ld	hl,RS_ERR_NO_DATA
	in	a,(TTSTAT)
	and	1
	ret	z		;Not ready
	in	a,(TTDATA)
	ld	(de),a
	ld	hl,RS_ERR_OK
	ret
#endasm
}

