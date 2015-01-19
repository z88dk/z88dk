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
; $Id: ozrestorescreen.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozrestorescreen
	
	EXTERN	ozsccopy
	
	EXTERN	ozactivepage


.ozrestorescreen
        ld      de,968h
        push    de
        ld      hl,0
        push    hl
        ld      h,4  ;; l=0 still
        ld      de,(ozactivepage)
        jp      ozsccopy

