/*
 *	z88dk RS232 Function
 *
 *	z88 version
 *
 *	unsigned char rs232_params(unsigned char param, unsigned char parity)
 *
 *	Specify the serial interface parameters
 *
 *	Later on, this should set panel values
 */


#include <rs232.h>


#if 0
#asm
        INCLUDE "director.def"
#endasm
#endif

u8_t __FASTCALL__ rs232_params(unsigned char param, unsigned char parity)
{
#if 0
    {
	/* Unfinished code */
	unsigned u16_t baud;

	switch ( param & 0x0F ) {
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
	case RS_BAUD_9600:
	    baud = 9600;
	    break;       
	case RS_BAUD_19200:     /* Available but broken */
	case RS_BAUD_38400:     /* Availabe but broken */
	case RS_BAUD_57600:
	case RS_BAUD_115200:
	case RS_BAUD_230400:
	    return  RS_ERR_BAUD_TOO_FAST;
	case RS_BAUD_50:
	case RS_BAUD_110:
	case RS_BAUD_134_5:
	case RS_BAUD_4800:
	default:
	    return RS_ERR_BAUD_NOT_AVAIL;
	}
	rs232_setbaud(&baud);
    }
    {
	u8_t  par;
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
	rs232_setparity(&par);
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
    push hl
    ld   bc,PA_Txb
    ld   a,2
    call_oz(os_sp)
    pop  hl
    ld   a,2	
    ld bc,PA_Rxb
    call_oz(os_sp)
#endasm

static void rs232_setparity(u8_t *baud)
{
#asm
    pop  bc
    pop  hl
    push hl
    push bc
    ld   bc,PA_Par
    ld   a,1
    call_oz(os_sp) 
#endasm
}
#endif







