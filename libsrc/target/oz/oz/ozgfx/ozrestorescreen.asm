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
; $Id: ozrestorescreen.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

	SECTION code_clib
	PUBLIC	ozrestorescreen
	PUBLIC	_ozrestorescreen
	
	EXTERN	ozsccopy
	
	EXTERN	ozactivepage


.ozrestorescreen
._ozrestorescreen
        ld      de,968h
        push    de
        ld      hl,0
        push    hl
        ld      h,4  ;; l=0 still
        ld      de,(ozactivepage)
        jp      ozsccopy

