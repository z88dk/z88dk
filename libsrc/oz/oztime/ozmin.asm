;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	clock functions
;
;	unsigned ozmin()
;
;
; ------
; $Id: ozmin.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozmin
	
	LIB	Compute	

ozmin:
        ld      c,33h
        jp      Compute
