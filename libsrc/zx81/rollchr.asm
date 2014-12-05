;
;       ZX81 libraries
;
;--------------------------------------------------------------
;
;       $Id: rollchr.asm,v 1.1 2014-12-05 17:35:50 stefano Exp $
;
;----------------------------------------------------------------
;
; rollchr(offset) - rotate every single character, offset 0..7
;
;----------------------------------------------------------------

        XLIB    rollchr
		XREF	MTCH_P2

rollchr:
		ld	a,l
		and 7
		inc a
		ld  (MTCH_P2+1),a
		ret
