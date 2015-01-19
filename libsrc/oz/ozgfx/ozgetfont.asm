;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	void ozgetfont(int font)
;
;
; ------
; $Id: ozgetfont.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozgetfont
	
	EXTERN	ScrCharSet

ozgetfont:
        ld      a,(ScrCharSet)
        ld      l,a
        ld      h,0
        ret
