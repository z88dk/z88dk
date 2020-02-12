IF !__CPU_INTEL__ & !__CPU_GBZ80__

	SECTION	code_psg

	PUBLIC	ay_wyz_start_effect
	PUBLIC	_ay_wyz_start_effect
	EXTERN	asm_wyz_start_effect


;void ay_wyz_start_effect(int channel, void *effect_table);
ay_wyz_start_effect:
_ay_wyz_start_effect:
	pop	bc	;return address
	pop	hl	;table
	pop	de	;channel
	push	de
	push	hl
	push	bc
	ld	a,c
	call	asm_wyz_start_effect
	ret
ENDIF
