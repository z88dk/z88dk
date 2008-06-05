/*
 *      z88dk RS232 Function
 *
 *      ZX Spectrum (interface 1) version
 *
 *      unsigned char rs232_put(char)
 *
 *      No error checking, for now.
 *
 *      $Id: rs232_put.c,v 1.2 2008-06-05 14:31:24 stefano Exp $
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_put(i8_t char)
{       
#asm
        ld      a,l     ;get byte
        rst     8
        defb    $1E
        ld      hl,RS_ERR_OK
#endasm
}


