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
; $Id: ozyear.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	ozyear
	
	EXTERN	Compute	

ozyear:
        ld      c,3ch
        call    Compute
        ld      de,2000
        add     hl,de
        ret

