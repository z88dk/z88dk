; WYZ player
;
; Hardware output routine for SAM Coupe via emulation
;
;

	SECTION	code_psg

	PUBLIC	asm_wyz_hardware_out

	EXTERN	asm_wyz_PSG_REG
	EXTERN	asm_wyz_PSG_REG_SEC
	EXTERN	asm_wyz_ENVOLVENTE_BACK
        EXTERN  asm_saa_ay_play


asm_wyz_hardware_out:
    LD      A,(asm_wyz_PSG_REG+13)
    AND     A           ;ES CERO?
    JR      Z,NO_BACKUP_ENVOLVENTE
    LD      (asm_wyz_ENVOLVENTE_BACK),A ;08.13 / GUARDA LA ENVOLVENTE EN EL BACKUP
NO_BACKUP_ENVOLVENTE:
;VUELCA BUFFER DE SONIDO AL PSG DEL SPECTRUM

    push    ix
    ld      ix,asm_wyz_PSG_REG_SEC
    call    asm_saa_ay_play
    pop     ix
    XOR     A
    LD      (asm_wyz_PSG_REG_SEC+13),A
    LD      (asm_wyz_PSG_REG+13),A
    RET
