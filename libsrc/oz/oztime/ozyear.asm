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
; $Id: ozyear.asm,v 1.1 2003-10-21 17:15:22 stefano Exp $
;

	XLIB	ozyear
	
	LIB	Compute	

ozyear:
        ld      c,3ch
        call    Compute
        ld      de,2000
        add     hl,de
        ret

