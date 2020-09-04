/*
 *      z88dk RS232 Function
 *
 *      ZX Spectrum (interface 1) version
 *
 *      unsigned char rs232_init()
 *
 *      Initialise the serial interface
 *
 *      $Id: rs232_init.c,v 1.3 2008-06-06 16:07:33 stefano Exp $
 */


#include <rs232.h>


u8_t rs232_init()
{
#asm
    PUBLIC BAUD
    PUBLIC SERFL

    BAUD:
        ; Default speed: 2400 baud
        defw $36
    SERFL:
        ; flag + data byte about an eventual 2nd character already transmitted
        defw 0

        ld      hl,RS_ERR_OK
#endasm
}
