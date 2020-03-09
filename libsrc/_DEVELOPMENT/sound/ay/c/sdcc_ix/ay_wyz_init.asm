IF !__CPU_INTEL__ && !__CPU_GBZ80__

	SECTION	code_psg

	PUBLIC	_ay_wyz_init


        EXTERN  asm_wyz_player_init
        EXTERN  asm_wyz_TABLA_PAUTAS
        EXTERN  asm_wyz_TABLA_SONIDOS
        EXTERN  asm_wyz_TABLA_SONG
        EXTERN  asm_wyz_DATOS_NOTAS

; void ay_wyz_init(wyz_song *song) __z88dk_fastcall
_ay_wyz_init:
	ld	c,(hl)	;instrument table
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	(asm_wyz_TABLA_SONIDOS),bc
	ld	c,(hl)	;effect
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	(asm_wyz_TABLA_PAUTAS),bc
	ld	c,(hl)	;note
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	(asm_wyz_DATOS_NOTAS),bc
	ld	c,(hl)	;song table
	inc	hl
	ld	b,(hl)
	ld	(asm_wyz_TABLA_SONG),bc
	call	asm_wyz_player_init
	ret


ENDIF
