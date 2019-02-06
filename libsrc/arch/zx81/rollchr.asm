;
;       ZX81 libraries
;
;--------------------------------------------------------------
;
;       $Id: rollchr.asm,v 1.3 2016-06-26 20:32:08 dom Exp $
;
;----------------------------------------------------------------
;
; rollchr(offset) - rotate every single character, offset 0..7
;
;----------------------------------------------------------------

        SECTION code_clib
        PUBLIC    rollchr
        PUBLIC    _rollchr
		EXTERN	MTCH_P2

rollchr:
_rollchr:
		ld	a,l
		and 7
		inc a
		ld  (MTCH_P2+1),a
		ret
