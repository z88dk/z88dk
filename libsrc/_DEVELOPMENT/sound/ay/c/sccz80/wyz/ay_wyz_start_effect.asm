IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	ay_wyz_start_effect
	PUBLIC	ay_wyz_start_effect_callee
	EXTERN	asm_wyz_start_effect

ay_wyz_start_effect_callee:
	pop	bc	;return address
	pop	hl	;number
	pop	de	;channel
	push	bc
	jr	start_effect

;void ay_wyz_start_effect(int channel, int effect_number)
ay_wyz_start_effect:
	pop	bc	;return address
	pop	hl	;number
	pop	de	;channel
	push	de
	push	hl
	push	bc
start_effect:
	ld	a,e	;channel
	ld	b,l	;effect number
	push	ix
	push	iy
	call	asm_wyz_start_effect
	pop	iy
	pop	ix
	ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_start_effect
defc _ay_wyz_start_effect = ay_wyz_start_effect
ENDIF
ENDIF
