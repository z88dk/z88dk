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
; $Id: ozsetrxhandshaking.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozsetrxhandshaking

	EXTERN	serial_int
	EXTERN	SerialBuffer
	EXTERN	ozrxhandshaking
	EXTERN	ozrxxoff


ozsetrxhandshaking:
        pop     hl
        pop     de
        push    de

        ld      a,e
        or      a
        jr      z,load_it
        ld      a,0
load_it:
        ld      (ozrxhandshaking),a

        xor     a
        ld      (ozrxxoff),a

        jp      (hl)

