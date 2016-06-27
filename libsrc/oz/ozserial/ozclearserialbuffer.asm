;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	Serial libraries
;	buffered serial input
;
; ------
; $Id: ozclearserialbuffer.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozclearserialbuffer
	PUBLIC	_ozclearserialbuffer

	EXTERN	serial_int
	EXTERN	SerialBuffer
	EXTERN	ozserbufget
	EXTERN	ozrxxoff


ozclearserialbuffer:
_ozclearserialbuffer:
        ld      hl,ozserbufget
        ld      a,(hl)
        inc     hl
        ld      (hl),a
        xor     a
        ld      (ozrxxoff),a
        ret
