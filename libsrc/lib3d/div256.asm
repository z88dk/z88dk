;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int div256(long value);
;	divide by 256
;
; ------
; $Id: div256.asm,v 1.3 2016-06-28 19:31:42 dom Exp $
;

	SECTION code_clib
	PUBLIC	div256
	PUBLIC	_div256

div256:
_div256:
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
