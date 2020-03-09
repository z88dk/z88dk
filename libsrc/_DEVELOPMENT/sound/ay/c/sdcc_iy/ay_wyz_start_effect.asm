IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_psg

	PUBLIC	_ay_wyz_start_effect
	EXTERN	asm_wyz_start_effect


;void ay_wyz_start_effect(int channel, int effect_number)
_ay_wyz_start_effect:
	pop	bc	;return address
	pop	hl	;number
	pop	de	;channel
	push	de
	push	hl
	push	bc
	ld	a,e	;channel
	ld	b,l	;effect number
	push	ix
	push	iy
	call	asm_wyz_start_effect
	pop	iy
	pop	ix
	ret
ENDIF
