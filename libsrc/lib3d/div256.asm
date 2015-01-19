;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int div256(long value);
;	divide by 256
;
; ------
; $Id: div256.asm,v 1.2 2015-01-19 01:32:54 pauloscustodio Exp $
;

	PUBLIC	div256

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
