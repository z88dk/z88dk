;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozsec()
;
;
; ------
; $Id: ozsec.asm,v 1.1 2003-10-21 17:15:22 stefano Exp $
;

	XLIB	ozsec
	
	LIB	Compute	

ozsec:
        ld      c,31h
        jp      Compute
