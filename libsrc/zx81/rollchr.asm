;
;       ZX81 libraries
;
;--------------------------------------------------------------
;
;       $Id: rollchr.asm,v 1.2 2015-01-19 01:33:26 pauloscustodio Exp $
;
;----------------------------------------------------------------
;
; rollchr(offset) - rotate every single character, offset 0..7
;
;----------------------------------------------------------------

        PUBLIC    rollchr
		EXTERN	MTCH_P2

rollchr:
		ld	a,l
		and 7
		inc a
		ld  (MTCH_P2+1),a
		ret
