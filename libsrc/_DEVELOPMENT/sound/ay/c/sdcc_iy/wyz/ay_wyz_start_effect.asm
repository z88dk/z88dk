IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	_ay_wyz_start_effect
	PUBLIC	_ay_wyz_start_effect_callee
	EXTERN	asm_wyz_start_effect

_ay_wyz_start_effect_callee:
	pop	bc	;return address
	pop	de	;channel
	pop	hl	;number
	push	bc
	jr	start_effect


;void ay_wyz_start_effect(int channel, int effect_number)
_ay_wyz_start_effect:
	pop	bc	;return address
	pop	de	;channel
	pop	hl	;number
	push	hl
	push	de
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
ENDIF
