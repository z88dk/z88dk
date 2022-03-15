; WYZ player
;
; Hardware output routine for +gal
;
;

	SECTION	code_psg

	PUBLIC	asm_wyz_hardware_out

	EXTERN	asm_wyz_PSG_REG
	EXTERN	asm_wyz_PSG_REG_SEC
	EXTERN	asm_wyz_ENVOLVENTE_BACK


asm_wyz_hardware_out:
    LD      A,(asm_wyz_PSG_REG+13)
    AND     A           ;ES CERO?
    JR      Z,NO_BACKUP_ENVOLVENTE
    LD      (asm_wyz_ENVOLVENTE_BACK),A     ;08.13 / GUARDA LA ENVOLVENTE EN EL BACKUP
    XOR     A
NO_BACKUP_ENVOLVENTE:
    LD      BC,$00
    LD      HL,asm_wyz_PSG_REG_SEC
LOUT:
    OUT     (C),A
    INC     C
    OUTI
    DEC     C
    INC     A
    CP      13
    JR      NZ,LOUT
    OUT     (0),A
    LD      A,(HL)
    AND     A
    RET     Z
    OUT     (1),A
    XOR     A
    LD      (asm_wyz_PSG_REG_SEC+13),A
    LD      (asm_wyz_PSG_REG+13),A
    RET

