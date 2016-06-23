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


//u8_t rs232_get(i8_t *char)
#asm
	SECTION code_clib
.rs232_get
._rs232_get
	INCLUDE	"serintfc.def"
	push	hl	;save address
	ld	l,SI_GBT
	ld	bc,0	;timeout
	call_oz(os_si)	;preserves ix
	pop	de	;address
	ld	hl,RS_ERR_NO_DATA
	ret	c
	ld	(de),a
	ld	hl,RS_ERR_OK
	ret
#endasm


