/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum (interface 1) version
 *
 *	unsigned char rs232_put(char)
 *
 *	No error checking, for now.
 */


#include <rs232.h>


u8_t rs232_put(i8_t char)
{	/* Fastcall so implicit push */
#asm
	ld	a,l	;get byte
	rst	8
	defb	$1E
	ld	hl,RS_ERR_OK
	pop	bc	;remove implicit push
	ret
#endasm
}


