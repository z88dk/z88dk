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
; $Id: ozgetfont.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozgetfont
	PUBLIC	_ozgetfont
	
	EXTERN	ScrCharSet

ozgetfont:
_ozgetfont:
        ld      a,(ScrCharSet)
        ld      l,a
        ld      h,0
        ret
