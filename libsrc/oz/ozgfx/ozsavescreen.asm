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
; $Id: ozsavescreen.asm,v 1.1 2003-10-21 17:15:20 stefano Exp $
;

	XLIB	ozsavescreen
	
	;LIB	ozrestorescreen
	XDEF	ozsccopy
	
	XREF	ozactivepage
	LIB	ozcopy


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
