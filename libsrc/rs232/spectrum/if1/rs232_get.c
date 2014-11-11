/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum (interface 1) version
 *
 *	unsigned char rs232_get(char *)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 *
 *      $Id: rs232_get.c,v 1.3 2014-11-11 15:23:42 stefano Exp $
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_get(i8_t *char)
{	/* fastcall so implicit push */
#asm
;        push	hl
	rst	8
	defb	$1d

	pop	de
	ld	hl,RS_ERR_NO_DATA
	ret	nc
	ld	(de),a
	ld	hl,RS_ERR_OK
	ret
	;;pop	bc; fastcall so implicit push
#endasm
}


