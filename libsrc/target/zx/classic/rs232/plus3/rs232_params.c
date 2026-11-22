/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum plus version
 *
 *	unsigned char rs232_params(unsigned char param, unsigned char parity)
 *
 *	Specify the serial interface parameters
 *
 *	Later on, this should set panel values
 *
 *      $Id: rs232_params.c,v 1.10 2015-01-21 08:27:13 stefano Exp $
 */

	/* BAUD system variable: 23391
		Value = (3500000/(25.7*BaudRate))-3
		this function should be right.. Stefano 21/5/2002 */

#include <rs232.h>

u8_t rs232_params(unsigned char param, unsigned char parity)
{
#asm
		EXTERN BAUD

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
        cp      12              ; max 9600 baud
		;cp      13              ; max 19200 baud
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
;        ld      (23391),hl
        ld      (BAUD),hl
        ld      hl,0            ; RS_ERR_OK
        ret

tabell:
        defw    2725   ;RS_BAUD_50
        defw    1814   ;RS_BAUD_75         ; experimental
        defw    1236   ;RS_BAUD_110
        defw    1009   ;RS_BAUD_134_5      ; experimental
        defw    904    ;RS_BAUD_150        ; experimental
        defw    451    ;RS_BAUD_300
        defw    224    ;RS_BAUD_600
        defw    110    ;RS_BAUD_1200
        defw    54     ;RS_BAUD_2400
        defw    25     ;RS_BAUD_4800
        defw    11     ;RS_BAUD_9600
        ;defw    4      ;RS_BAUD_19200      ; experimental, TX only

		
#endasm
}

