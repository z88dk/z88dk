/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum (interface 1) version
 *
 *	unsigned char rs232_get(char *)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 */


#include <rs232.h>


u8_t rs232_get(i8_t *char)
{	/* fastcall so implicit push */
#asm
	rst	8
	defb	$1d

	pop	de
	ld	hl,RS_ERR_OK
	jr	nc,exitget
	ld	(de),a
	ld	hl,RS_ERR_NO_DATA
.exitget
	push	bc		;any rubbish will do
#endasm
}


