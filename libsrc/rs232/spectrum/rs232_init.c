/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum (interface 1) version
 *
 *	unsigned char rs232_init()
 *
 *	Initialise the serial interface
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_init()
{
#asm
	rst	8
	defb	$31		; Create the IF1 system variables area
	xor	a
	ld	($5cc7),a	; Reset SER-FL to clean the input buffer
	ld	a,(23624)
	ld	(23750),a	; Set IOBORD to the current border colour (hide flashing)
	ld	hl,RS_ERR_OK
#endasm
}
