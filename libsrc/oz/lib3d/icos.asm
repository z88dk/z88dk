;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int icos(unsigned degrees);
;	input must be between 0 and 360
;
; ------
; $Id: icos.asm,v 1.1 2003-10-29 11:37:11 stefano Exp $
;

	XLIB	icos

	LIB	isin
	XREF	sin_start

icos:
        pop     de
        pop     bc
        push    bc
        push    de
        ld      hl,90
        or      a
        sbc     hl,bc
        jp      nc,sin_start
        ld      bc,360
        add     hl,bc
        jp      sin_start

