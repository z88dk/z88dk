/*
 *	z88dk RS232 Function — RC700 (Z80-SIO channel A / RDR+PUN)
 *
 *	uint8_t rs232_get(uint8_t *)
 *
 *	Non-blocking read.  If a character is available it is stored via the
 *	supplied pointer and RS_ERR_OK is returned; otherwise RS_ERR_NO_DATA.
 */

#include <arch/z80.h>
#include <rs232.h>
#include "rc700_sio.h"

uint8_t rs232_get(uint8_t *ptr) __z88dk_fastcall
{
    if ((z80_inp(SIO_A_CTRL) & SIO_RR0_RX_AVAIL) == 0)
        return RS_ERR_NO_DATA;
    *ptr = z80_inp(SIO_A_DATA);
    return RS_ERR_OK;
}
