
	SECTION	code_psg

	PUBLIC	ay_vt2_mute
	PUBLIC	_ay_vt2_mute
	EXTERN	asm_VT_MUTE


ay_vt2_mute:
_ay_vt2_mute:
	call	asm_VT_MUTE
	ret

