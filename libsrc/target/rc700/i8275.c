/*
 * Generic Intel 8275 CRT controller — RC700 device functions.
 *
 * Declared in <video/i8275.h>.  The RC700 wires the 8275 command/status
 * port at 0x01 and the parameter/data port at 0x00.
 *
 * Datasheet: https://bitsavers.org/components/intel/8275/1984_8275.pdf
 * RC700 issue: https://github.com/z88dk/z88dk/issues/3011
 */

#include <arch/z80.h>
#include <video/i8275.h>

/* Fill par[4] with the RC700 defaults (blinking block cursor). */
void i8275_default_par(unsigned char *par) __z88dk_fastcall
{
    par[0] = I8275_RC700_PAR0;   /* 80 chars/row                    */
    par[1] = I8275_RC700_PAR1;   /* 25 rows/frame                   */
    par[2] = I8275_RC700_PAR2;   /* underline line 7, 11 lines/char */
    par[3] = I8275_RC700_PAR3;   /* blinking block cursor           */
}

/* Reprogram the RC700 8275 from par[0..3] and re-enable the display. */
void i8275_reset(unsigned char *par) __z88dk_fastcall
{
    unsigned char i;

    z80_outp(I8275_RC700_CMD_PORT, I8275_CMD_RESET);
    for (i = 0; i < 4; i++)                     /* write par[0..3] */
        z80_outp(I8275_RC700_DATA_PORT, par[i]);

    z80_outp(I8275_RC700_CMD_PORT, I8275_CMD_LOAD_CURSOR);
    z80_outp(I8275_RC700_DATA_PORT, 0);         /* cursor column 0 */
    z80_outp(I8275_RC700_DATA_PORT, 0);         /* cursor row 0    */

    z80_outp(I8275_RC700_CMD_PORT, I8275_CMD_PRESET);
    z80_outp(I8275_RC700_CMD_PORT, I8275_RC700_START);
}
