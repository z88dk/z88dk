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
; $Id: ozgetrxhandshaking.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozgetrxhandshaking

	LIB	serial_int
	XREF	SerialBuffer
	XREF	ozrxhandshaking


ozgetrxhandshaking:
        ld      a,(ozrxhandshaking)
        ld	h,0
        ld	l,a
        ret
