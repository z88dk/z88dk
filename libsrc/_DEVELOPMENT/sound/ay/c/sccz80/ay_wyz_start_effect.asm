IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_psg

	PUBLIC	ay_wyz_start_effect
	EXTERN	asm_wyz_start_effect


;void ay_wyz_start_effect(int channel, int effect_number)
ay_wyz_start_effect:
	pop	bc	;return address
	pop	hl	;number
	pop	de	;channel
	push	de
	push	hl
	push	bc
	ld	a,e	;channel
	ld	b,l	;effect number
	call	asm_wyz_start_effect
	ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_start_effect
defc _ay_wyz_start_effect = ay_wyz_start_effect
ENDIF
ENDIF
