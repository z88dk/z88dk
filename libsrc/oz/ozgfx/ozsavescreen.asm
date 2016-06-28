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
; $Id: ozsavescreen.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozsavescreen
	PUBLIC	_ozsavescreen
	
	;LIB	ozrestorescreen
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
