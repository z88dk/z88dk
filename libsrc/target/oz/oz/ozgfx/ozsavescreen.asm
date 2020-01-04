;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;
;
; ------
; $Id: ozsavescreen.asm,v 1.4 2016-07-14 17:44:17 pauloscustodio Exp $
;

	SECTION code_clib
	PUBLIC	ozsavescreen
	PUBLIC	_ozsavescreen
	
	;EXTERN	ozrestorescreen
	PUBLIC	ozsccopy
	
	EXTERN	ozactivepage
	EXTERN	ozcopy


ozsavescreen:
_ozsavescreen:
        ld      de,0
        push    de
        ld      hl,968h
        push    hl
        ld      hl,(ozactivepage)
        ld      d,4  ;; e=0 still
ozsccopy:
        ld      bc,2400
        call    ozcopy
        pop     hl
        pop     hl
        ret
