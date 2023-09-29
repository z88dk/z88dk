;
;       ZX81 and LAMBDA libraries
;
;--------------------------------------------------------------
;
;       $Id: rollchr.asm $
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
		ld de,MTCH_P2+1
		ld a,(7)
		cp $1d		; LAMBDA MONO ROM ?
		jr z,zx81mode
		cp 3		; ZX81 ROM ?
		jr z,zx81mode
		inc de
zx81mode:
		ld	a,l
		and 7
		inc a
		ld  (de),a
		ret
