/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum (interface 1) version
 *
 *	unsigned char rs232_params(unsigned char param, unsigned char parity)
 *
 *	Specify the serial interface parameters
 *
 *	Later on, this should set panel values
 */

	/* BAUD system variable: 23747
		Value = (3500000/(26*BaudRate))-2 */

#include <rs232.h>


u8_t __FASTCALL__ rs232_params(unsigned char param, unsigned char parity)
{
#if 0
    {
	/* Unfinished code */
	unsigned u16_t baud;

	switch ( param & 0x0F ) {
	case RS_BAUD_50:
	    baud = 50;
	    break;
	case RS_BAUD_110:
	    baud = 110;
	    break;
	case RS_BAUD_300:
	    baud = 300;
	    break;
	case RS_BAUD_600:
	    baud = 600;
	    break;
	case RS_BAUD_1200:
	    baud = 1200;
	    break;
	case RS_BAUD_2400:
	    baud = 2400;
	    break;
	case RS_BAUD_4800:
	    baud = 4800;
	    break;
	case RS_BAUD_9600:
	    baud = 9600;
	    break;
	case RS_BAUD_19200:     /* Not perfect but works */
	    baud = 19200;
	    break;
	case RS_BAUD_38400:     /* Let's try... ! */
	    baud = 38400;
	    break;
	case RS_BAUD_57600:
	case RS_BAUD_115200:
	case RS_BAUD_230400:
	    return  RS_ERR_BAUD_TOO_FAST;

	default:
	case RS_BAUD_134_5:
	    return RS_ERR_BAUD_NOT_AVAIL;
	}
	baud=(3500000/(26*baud))-2;
	rs232_setbaud(&baud);
    }
    /*
    {
	u8_t  par;

	if ( ( parity & 0xE0) != RS_PAR_NONE)
	    return RS_ERR_PARITY_NOT_AVAIL;

	switch ( parity ) {
	case RS_PAR_NONE:
	    par = 'N';
	    break;
	case RS_PAR_ODD:
	    par = 'O';
	    break;
	case RS_PAR_EVEN:
	    par = 'E';
	    break;
	case RS_PAR_MARK:
	    par = 'M';
	    break;
	case RS_PAR_SPACE:
	    par = 'S';
	    break;
	}
    */
    }	      
#endif
    return RS_ERR_OK;
}

#if 0
static void rs232_setbaud(u16_t *baud)
{
#asm
    pop  bc
    pop  hl
    push hl
    push bc
    ld	a,l
    ld	(23747),a
#endasm
}
#endif

