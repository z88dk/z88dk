;
;		Direct I/O to the second Z80 CPU for the video generation
;		'Fading' CLS effect.
;
;		Stefano Bodrato, 2023
;
;
;	$Id: mbc_fade.asm $
;
		SECTION code_clib

		PUBLIC    mbc_fade
		PUBLIC    _mbc_fade
		
		EXTERN  mbc_sub
		EXTERN  mbc_sendchar


mbc_fade:
_mbc_fade:

	ld hl,fade_code
	ld de,fade_end-fade_code
	call mbc_sub

	ld a,26			; CLS
	jp mbc_sendchar
	

;----------------------------------------------------------------


fade_code:
		;push bc		; BC holds the cursor position and should be preserved, but CLS will reset it
		ld b,8

fade_loop_0:
		ld hl,$8000
		ld de,$8000

fade_loop:
		ld a,(hl)
		srl a
		ld (hl),a
		
		inc hl
		dec de
		
		ld a,d
		or e
		jr nz,fade_loop

		djnz fade_loop_0
		;pop bc
		
		ret

fade_end:
