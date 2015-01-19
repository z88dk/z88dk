;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int icos(unsigned degrees);
;	input must be between 0 and 360
;
; ------
; $Id: icos.asm,v 1.2 2015-01-19 01:32:54 pauloscustodio Exp $
;

	PUBLIC	icos

	EXTERN	isin

icos:
	; __FASTCALL__
	ld	b,h
	ld	c,l

        ld      hl,90
        or      a
        sbc     hl,bc
        jp      nc,isin
        ld      bc,360
        add     hl,bc
        jp      isin

