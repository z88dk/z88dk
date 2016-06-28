;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	int icos(unsigned degrees);
;	input must be between 0 and 360
;
; ------
; $Id: icos.asm,v 1.3 2016-06-28 19:31:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	icos
	PUBLIC	_icos

	EXTERN	isin

icos:
_icos:
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

