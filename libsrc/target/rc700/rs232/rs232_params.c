/*
 *	z88dk RS232 Function — RC700 (Z80-SIO channel A / RDR+PUN)
 *
 *	uint8_t rs232_params(uint8_t params, uint8_t parity)
 *
 *	Configure SIO-A: baud (via CTC ch0), stop bits, data bits and parity.
 *	Following the Classic-Serial contract, this does the full hardware
 *	setup (like +svi); rs232_init() is then a no-op.
 *
 *	  params: RS_BAUD_* in the low nibble, optionally | RS_STOP_2 | RS_BITS_*
 *	  parity: RS_PAR_NONE / RS_PAR_ODD / RS_PAR_EVEN
 *
 *	Returns RS_ERR_BAUD_TOO_FAST or RS_ERR_BAUD_NOT_AVAIL when the CTC
 *	cannot generate the requested rate, else RS_ERR_OK.
 */

#include <arch/z80.h>
#include <rs232.h>
#include "rc700_sio.h"

/* CTC time constant per RS_BAUD_* code; baud = 38400 / TC.  0 = the rate
 * is not generatable (TC would be non-integer or exceed 256).  TC 256 is
 * written to the CTC as 0 (the CTC treats a 0 constant as 256).
 *
 * 38400 (TC=1) is the ceiling: the SIO runs the x16 divider (WR4), so
 * baud = CTC_clock/16 = 614400/16/TC.  Going faster would need the SIO's
 * x1 divider, which has NOT been verified on the real Z80-SIO here, so
 * 57600/115200/230400 are reported RS_ERR_BAUD_TOO_FAST rather than
 * silently mis-clocked.  Lift the ceiling only once x1 is proven. */
static const uint16_t baud_tc[16] = {
    0,      /* RS_BAUD_50     */  0,      /* RS_BAUD_75     */
    0,      /* RS_BAUD_110    */  0,      /* RS_BAUD_134_5  */
    256,    /* RS_BAUD_150    */  128,    /* RS_BAUD_300    */
    64,     /* RS_BAUD_600    */  32,     /* RS_BAUD_1200   */
    16,     /* RS_BAUD_2400   */  8,      /* RS_BAUD_4800   */
    4,      /* RS_BAUD_9600   */  2,      /* RS_BAUD_19200  */
    1,      /* RS_BAUD_38400  */  0,      /* RS_BAUD_57600  */
    0,      /* RS_BAUD_115200 */  0       /* RS_BAUD_230400 */
};

uint8_t rs232_params(uint8_t params, uint8_t parity) __smallc
{
    uint8_t  baud = params & 0x0F;
    uint16_t tc   = baud_tc[baud];
    uint8_t  wr4, wr3, wr5;

    if (tc == 0)
        return (baud > RS_BAUD_38400) ? RS_ERR_BAUD_TOO_FAST
                                      : RS_ERR_BAUD_NOT_AVAIL;

    /* WR4: x16 clock + stop bits + parity */
    wr4 = SIO_WR4_X16;
    wr4 |= (params & RS_STOP_2) ? SIO_WR4_STOP2 : SIO_WR4_STOP1;
    if (parity == RS_PAR_ODD)  wr4 |= SIO_WR4_PAR_EN;
    if (parity == RS_PAR_EVEN) wr4 |= SIO_WR4_PAR_EN | SIO_WR4_PAR_EVEN;

    /* Bits/char: WR3 holds Rx bits (b6-7), WR5 holds Tx bits (b5-6). */
    switch (params & 0x60) {
        case RS_BITS_5: wr3 = 0x00; wr5 = 0x00; break;
        case RS_BITS_6: wr3 = 0x80; wr5 = 0x20; break;
        case RS_BITS_7: wr3 = 0x40; wr5 = 0x00; break;
        default:        wr3 = 0xC0; wr5 = 0x60; break;  /* RS_BITS_8 */
    }
    wr3 |= SIO_WR3_RX_EN;
    wr5 |= SIO_WR5_TX_EN | SIO_WR5_RTS;

    /* Program the CTC baud generator, then the SIO channel. */
    z80_outp(CTC0, CTC0_CTRL);
    z80_outp(CTC0, (uint8_t)tc);

    z80_outp(SIO_A_CTRL, SIO_WR0_RESET);
    z80_outp(SIO_A_CTRL, SIO_WR4_PTR);  z80_outp(SIO_A_CTRL, wr4);
    z80_outp(SIO_A_CTRL, SIO_WR3_PTR);  z80_outp(SIO_A_CTRL, wr3);
    z80_outp(SIO_A_CTRL, SIO_WR5_PTR);  z80_outp(SIO_A_CTRL, wr5);
    z80_outp(SIO_A_CTRL, SIO_WR1_PTR);  z80_outp(SIO_A_CTRL, SIO_WR1_NO_INT);

    return RS_ERR_OK;
}
