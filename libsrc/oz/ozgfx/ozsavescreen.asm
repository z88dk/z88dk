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
; $Id: ozsavescreen.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozsavescreen
	
	;LIB	ozrestorescreen
	PUBLIC	ozsccopy
	
	EXTERN	ozactivepage
	EXTERN	ozcopy


ozsavescreen:
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
