/*
 *      z88dk RS232 Function
 *
 *      ZX Spectrum (Morex,B&V,Indescomp) version
 *
 *      unsigned char rs232_params(unsigned char param, unsigned char parity)
 *
 *      Specify the serial interface parameters
 *
 *      Later on, this should set panel values
 *
 *      $Id: rs232_params.c $
 */


#include <rs232.h>


u8_t rs232_params(unsigned char param, unsigned char parity)
{
#asm

    extern __BV_BAUD

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
init_err:
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
		or      h             ; Not a supported baud rate ?
		jr      z,init_err
		
        ld      (__BV_BAUD),hl
        ld      hl,0            ; RS_ERR_OK
        ret

tabell:
        defw    $057D   ;RS_BAUD_50          ; on the manual it is mentioned $147D, but looks rather big
        defw    $0514   ;RS_BAUD_75          ; ** experimental **
        defw    $04E1   ;RS_BAUD_110
        defw    $04B7   ;RS_BAUD_134_5       ; ** experimental **
        defw    $04A5   ;RS_BAUD_150
        defw    $0423   ;RS_BAUD_300         ; on the manual it was $0453, slightly adjusted, ** experimental **
        defw    $0329   ;RS_BAUD_600         ; on the manual it was $0429 but seemed too high, ** experimental **
        defw    $021F   ;RS_BAUD_1200
        defw    $0113   ;RS_BAUD_2400
        defw    $0070   ;RS_BAUD_4800        ; on the manual it was $0107.   ** experimental **
        defw    $0   ;RS_BAUD_9600           ; experimental
        defw    $0   ;RS_BAUD_19200          ; ** not supported **
        defw    $0   ;RS_BAUD_38400          ; ** not supported **



#endasm
}
