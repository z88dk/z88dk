;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozhour()
;
;
; ------
; $Id: ozhour.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozhour

	LIB	Compute	

ozhour:
        ld      c,35h
        jp      Compute
