/*
 *	z88dk RS232 Function — RC700 (Z80-SIO channel A / RDR+PUN)
 *
 *	uint8_t rs232_put(uint8_t)
 *
 *	Block until the SIO-A Tx buffer is empty, then send one byte.
 */

#include <arch/z80.h>
#include <rs232.h>
#include "rc700_sio.h"

uint8_t rs232_put(uint8_t c) __z88dk_fastcall
{
    while ((z80_inp(SIO_A_CTRL) & SIO_RR0_TX_EMPTY) == 0) { }
    z80_outp(SIO_A_DATA, c);
    return RS_ERR_OK;
}
