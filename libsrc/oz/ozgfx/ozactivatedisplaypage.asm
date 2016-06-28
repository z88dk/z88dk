;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	Videmo memory page handling
;
;
; ------
; $Id: ozactivatedisplaypage.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozactivatedisplaypage
	PUBLIC	_ozactivatedisplaypage
	
	EXTERN	ozactivepage


ozactivatedisplaypage:
_ozactivatedisplaypage:
        in      a,(22h)
        ld      (ozactivepage),a
;       in      a,(23h)
;       and     0fh
;       ld      (ozactivepage+1),a
        ret
