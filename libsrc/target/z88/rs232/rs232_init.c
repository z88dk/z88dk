/*
 *	z88dk RS232 Function
 *
 *	z88 version
 *
 *	unsigned char rs232_init()
 *
 *	Initialise the serial interface
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_init()
{
#asm
	INCLUDE	"serintfc.def"
	ld	l,SI_SFT
	call_oz(os_si)
	ld	hl,RS_ERR_OK
#endasm
}
