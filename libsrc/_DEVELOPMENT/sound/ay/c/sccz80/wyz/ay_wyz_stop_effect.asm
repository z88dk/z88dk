IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	ay_wyz_stop_effect
	EXTERN	asm_wyz_stop_effect


;void ay_wyz_stop_effect(void)
ay_wyz_stop_effect:
	call	asm_wyz_stop_effect
	ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_stop_effect
defc _ay_wyz_stop_effect = ay_wyz_stop_effect
ENDIF
ENDIF
