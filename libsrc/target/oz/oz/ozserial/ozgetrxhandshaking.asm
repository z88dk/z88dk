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
; $Id: ozgetrxhandshaking.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozgetrxhandshaking
	PUBLIC	_ozgetrxhandshaking

	EXTERN	serial_int
	EXTERN	SerialBuffer
	EXTERN	ozrxhandshaking


ozgetrxhandshaking:
_ozgetrxhandshaking:
        ld      a,(ozrxhandshaking)
        ld	h,0
        ld	l,a
        ret
