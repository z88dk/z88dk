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
; $Id: ozgetrxhandshaking.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozgetrxhandshaking

	EXTERN	serial_int
	EXTERN	SerialBuffer
	EXTERN	ozrxhandshaking


ozgetrxhandshaking:
        ld      a,(ozrxhandshaking)
        ld	h,0
        ld	l,a
        ret
