/*
 *	z88dk RS232 Function
 *
 *	z88 version
 *
 *	uint8_t rs232_params(uint8_t param, uint8_t parity)
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

uint8_t rs232_params(uint8_t param, uint8_t parity) __naked
{
#asm
	INCLUDE	"target/svi/def/sviserial.def"
        pop     af
        pop     bc      ;c = parity
        pop     de      ;e = param
        push    de
        push    bc
        push    af
        ld      b,e
        ld      a,e
        and     15
        add     a
        ld      e,a
        ld      d,0
        ld      hl,baud_divisors
        add     hl,de
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      a,d
        or      e
        ld      hl,RS_ERR_BAUD_NOT_AVAIL
        ret     z
        xor     a       ;Burp 8250
        out     (TTSTAT),a
        ld      a,$f    ;Activate all modem control lines
        out     (TTMCR),a
        xor     a       ;Disable all interrupts
        out     (TTIER),a
        ld      a,$83   ;Enable divisor latch
        out     (TTLCR), a
        ld      a,e     ;LSB
        out     (DLL),a
        ld      a,d     ;MSB
        out     (DLH),a
        ld      a,b     ;Get back bit + stopinformation
; Conversion between z88dk and 8250 character bits:
;
; Bits  z88dk   8250
;  5    $60     $00
;  6    $40     $01
;  7    $20     $02
;  8    $00     $11
        rlca            ;Convert
        rlca
        rlca
        cpl
        and     3
        bit     7,b     ;Set for 2 stop bits
        jr      z,one_stop_bit
        set     2,a
one_stop_bit:
; Parity
;  NONE         0x00    ..000...
;  EVEN         0x60    ..011...
;  ODD          0x20    ..001...
;  MARK         0xA0    ..101...
;  SPACE        0xE0    ..111...
        ld      e,a
        ld      a,b
        rlca
        and     @00111000
        or      e
        out     (TTLCR),a       ;And output it
        xor     a       ;Burp again
        out     (TTSTAT),a
        ld      hl,RS_ERR_OK
        ret

	SECTION	rodata_clib
baud_divisors:
	defw	3840	;50
	defw	2560	;75
	defw	1745	;110
	defw	1428	;134.5
	defw	1280	;150
	defw	640	;300
	defw	320	;600
	defw	160	;1200
	defw	80	;2400
	defw	40	;4800
	defw	20	;9600
	defw	10	;19200
	defw	5	;38400
	defw	0	;57600
	defw	0	;115200
	defw	0	;230400
#endasm
}

