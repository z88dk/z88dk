IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	_ay_wyz_effect_init
	PUBLIC	_ay_wyz_effect_init_fastcall
	EXTERN	asm_wyz_TABLA_EFECTOS


;void ay_wyz_effect_init(wyz_effects *effects) __z88dk_fastcall
_ay_wyz_effect_init:
	pop	bc
	pop	hl
	push	hl
	push	bc
_ay_wyz_effect_init_fastcall:
	ld	(asm_wyz_TABLA_EFECTOS),hl
	ret


ENDIF
