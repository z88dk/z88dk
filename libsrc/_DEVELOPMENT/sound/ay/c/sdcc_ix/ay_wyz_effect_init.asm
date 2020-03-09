IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_psg

	PUBLIC	_ay_wyz_effect_init
	EXTERN	asm_wyz_TABLA_EFECTOS


;void ay_wyz_effect_init(wyz_effects *effects) __z88dk_fastcall
_ay_wyz_effect_init:
	ld	(asm_wyz_TABLA_EFECTOS),hl
	ret


ENDIF
