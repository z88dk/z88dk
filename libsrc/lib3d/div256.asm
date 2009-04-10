;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int div256(long value);
;	divide by 256
;
; ------
; $Id: div256.asm,v 1.1 2009-04-10 12:47:42 stefano Exp $
;

	XLIB	div256

div256:
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
	
	; DEHL holds value
	
	ld	l,h
	ld	h,e

        ret
