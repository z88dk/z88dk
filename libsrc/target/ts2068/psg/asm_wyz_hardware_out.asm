; WYZ player
;
; Hardware output routine for ZX
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
    LD      (asm_wyz_ENVOLVENTE_BACK),A ;08.13 / GUARDA LA ENVOLVENTE EN EL BACKUP
NO_BACKUP_ENVOLVENTE:
;VUELCA BUFFER DE SONIDO AL PSG DEL SPECTRUM

    XOR     A
ROUT_A0:
    LD      DE,$f5f6
    LD      BC,$f5
    LD      HL,asm_wyz_PSG_REG_SEC
LOUT:
    OUT     (C),A
    LD      c,e
    OUTI
    LD      c,d
    INC     A
    CP      13
    JR      NZ,LOUT
    OUT     (C),A
    LD      A,(HL)
    AND     A
    RET     Z
    LD      c,E
    OUTI
    XOR     A
    LD      (asm_wyz_PSG_REG_SEC+13),A
    LD      (asm_wyz_PSG_REG+13),A
    RET
