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
; $Id: ozsetrxhandshaking.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozsetrxhandshaking

	LIB	serial_int
	XREF	SerialBuffer
	XREF	ozrxhandshaking
	XREF	ozrxxoff


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

