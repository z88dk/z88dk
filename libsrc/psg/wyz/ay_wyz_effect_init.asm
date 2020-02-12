IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_psg

	PUBLIC	ay_wyz_effect_init
	PUBLIC	_ay_wyz_effect_init
	EXTERN	asm_wyz_TABLA_EFECTOS


;void ay_wyz_effect_init(wyz_effects *effects)
ay_wyz_effect_init:
_ay_wyz_effect_init:
	pop	bc	;return address
	pop	hl	;table
	push	hl
	push	bc
	ld	(asm_wyz_TABLA_EFECTOS),hl
	ret
ENDIF
