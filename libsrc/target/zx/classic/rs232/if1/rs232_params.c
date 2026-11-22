/*
 *      z88dk RS232 Function
 *
 *      ZX Spectrum (interface 1) version
 *
 *      unsigned char rs232_params(unsigned char param, unsigned char parity)
 *
 *      Specify the serial interface parameters
 *
 *      Later on, this should set panel values
 *
 *      $Id: rs232_params.c,v 1.6 2012-12-12 17:28:06 stefano Exp $
 */

        /* BAUD system variable: 23747
                Value = (3500000/(26*BaudRate))-2 */

#include <rs232.h>


u8_t rs232_params(unsigned char param, unsigned char parity)
{
#asm
        rst     8
        defb    $31             ; Create the IF1 system variables area
        ;xor     a
        ;ld      ($5cc7),a       ; Reset SER-FL to clean the input buffer

        pop     bc
        pop     de
        pop     hl
        push    hl
        push    de
        push    bc
        
        xor     a
        and     e
        jr      z,noparity      ; parity not supported
        ld      hl,1            ; RS_ERR_NOT_INITIALIZED
        ret
noparity:
        ld      a,$f0
        and     l
        jr      z,noextra
        ld      hl,1            ; RS_ERR_NOT_INITIALIZED
        ret
noextra:
        ; baud rate
        ld      a,$0f
        and     l
        cp      14              ; max 38400 baud
        jr      c,avail
        ld      hl,2            ; RS_ERR_BAUD_TOO_FAST
        ret
avail:
        add     a,a
        ld      e,a
        ld      d,0
        ld      hl,tabell
        add     hl,de
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
        ld      (23747),hl
        ld      hl,0            ; RS_ERR_OK
        ret

tabell:
        defw    $0A82   ;RS_BAUD_50
        defw    $0701   ;RS_BAUD_75             ; experimental
        defw    $04C5   ;RS_BAUD_110
        defw    $03E6   ;RS_BAUD_134_5          ; experimental
        ; (a bug in cpp was changing the next line to:  defw $037. ;0x04 ; experimental ... now fixed)
        defw    $037F   ;RS_BAUD_150            ; experimental
        defw    $01BE   ;RS_BAUD_300
        defw    $00DE   ;RS_BAUD_600
        defw    $006E   ;RS_BAUD_1200
        defw    $0036   ;RS_BAUD_2400
        defw    $001A   ;RS_BAUD_4800
        defw    $000C   ;RS_BAUD_9600
        defw    $0005   ;RS_BAUD_19200
        defw    $0002   ;RS_BAUD_38400          ; experimental

#endasm
}
