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
; $Id: ozgetfont.asm,v 1.1 2003-10-21 17:15:20 stefano Exp $
;

	XLIB	ozgetfont
	
	XREF	ScrCharSet

ozgetfont:
        ld      a,(ScrCharSet)
        ld      l,a
        ld      h,0
        ret
