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


uint8_t rs232_get(uint8_t *char) __naked __z88dk_fastcall
{
#asm
        push    hl
        rst     $10
        pop     hl
        ld      (hl),a
        ld      hl,RS_ERR_OK
        ret
#endasm
}

