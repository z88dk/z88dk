/*
 *	z88dk RS232 Function
 *
 *	z88 version
 *
 *	unsigned char rs232_put(char)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 */


#include <rs232.h>


//u8_t rs232_put(i8_t char)
#asm
	SECTION code_clib
.rs232_put
._rs232_put
	INCLUDE	"serintfc.def"
	ld	a,l	;get byte
	ld	l,SI_PBT
	ld	bc,0	;timeout
	call_oz(os_si)		;preserves ix
	ld	hl,RS_ERR_OK
	ret	nc
	ld	hl,RS_ERR_OVERFLOW
	ret
#endasm


