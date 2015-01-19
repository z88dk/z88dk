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
; $Id: ozclearserialbuffer.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozclearserialbuffer

	EXTERN	serial_int
	EXTERN	SerialBuffer
	EXTERN	ozserbufget
	EXTERN	ozrxxoff


ozclearserialbuffer:
        ld      hl,ozserbufget
        ld      a,(hl)
        inc     hl
        ld      (hl),a
        xor     a
        ld      (ozrxxoff),a
        ret
