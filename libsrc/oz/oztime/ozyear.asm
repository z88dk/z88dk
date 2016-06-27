;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozyear()
;
;
; ------
; $Id: ozyear.asm,v 1.3 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozyear
	PUBLIC	_ozyear
	
	EXTERN	Compute	

ozyear:
_ozyear:
        ld      c,3ch
        call    Compute
        ld      de,2000
        add     hl,de
        ret

