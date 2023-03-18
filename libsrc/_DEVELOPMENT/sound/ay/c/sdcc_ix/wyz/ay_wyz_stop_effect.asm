IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	_ay_wyz_stop_effect
	EXTERN	asm_wyz_stop_effect


;void ay_wyz_stop_effect(void)
_ay_wyz_stop_effect:
	call	asm_wyz_stop_effect
	ret

ENDIF
