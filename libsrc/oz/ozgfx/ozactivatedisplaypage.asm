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
; $Id: ozactivatedisplaypage.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozactivatedisplaypage
	
	EXTERN	ozactivepage


ozactivatedisplaypage:
        in      a,(22h)
        ld      (ozactivepage),a
;       in      a,(23h)
;       and     0fh
;       ld      (ozactivepage+1),a
        ret
