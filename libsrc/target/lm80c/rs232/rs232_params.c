/*
 *	z88dk RS232 Function
 *
 *	z88 version
 *
 *	uint8_t rs232_params(uint8_t param, uint8_t parity)
 *
 *	Specify the serial interface parameters
 *
 *	Later on, this should set panel values
 */


#include <rs232.h>


uint8_t rs232_params(uint8_t param, uint8_t parity) __naked
{
#asm
        ld      hl,RS_ERR_OK
#endasm
}

