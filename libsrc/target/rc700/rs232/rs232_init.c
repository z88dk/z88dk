/*
 *	z88dk RS232 Function — RC700 (Z80-SIO channel A / RDR+PUN)
 *
 *	uint8_t rs232_init(void)
 *
 *	Initialise SIO-A for 8N1, Rx+Tx enabled, polled (no interrupts).
 *	Baud rate is set by the RC700 firmware's CTC ch0 timer.
 */

#include <arch/z80.h>
#include <rs232.h>
#include "rc700_sio.h"

uint8_t rs232_init(void)
{
    z80_outp(SIO_A_CTRL, SIO_WR0_RESET);
    z80_outp(SIO_A_CTRL, SIO_WR4_PTR);   z80_outp(SIO_A_CTRL, SIO_WR4_8N1_X16);
    z80_outp(SIO_A_CTRL, SIO_WR3_PTR);   z80_outp(SIO_A_CTRL, SIO_WR3_RX8_EN);
    z80_outp(SIO_A_CTRL, SIO_WR5_PTR);   z80_outp(SIO_A_CTRL, SIO_WR5_TX8_EN_RTS);
    z80_outp(SIO_A_CTRL, SIO_WR1_PTR);   z80_outp(SIO_A_CTRL, SIO_WR1_NO_INT);
    return RS_ERR_OK;
}
