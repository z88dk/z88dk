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


u8_t rs232_get(i8_t *char)
{	/* fastcall so implicit push */
#asm
	INCLUDE	"serintfc.def"
	ld	l,SI_GBT
	ld	bc,0	;timeout
	call_oz(os_si)
	pop	de
	ld	hl,RS_ERR_NO_DATA
	ret	c
	ld	(de),a
	ld	hl,RS_ERR_OK
	ret
	;push	bc		;any rubbish will do
#endasm
}


