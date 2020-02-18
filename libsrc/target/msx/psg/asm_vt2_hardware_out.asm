; Vortextracker II player
;
; Hardware output routine for MSX
;
;

	SECTION	code_psg

	PUBLIC	asm_vt_hardware_out
	PUBLIC	asm_vt_hardware_out_A0

	EXTERN	asm_VT_AYREGS


asm_vt_hardware_out:
    XOR     A
asm_vt_hardware_out_A0:
    LD      C,$A0
    LD      HL,asm_VT_AYREGS
LOUT:
    OUT     (C),A
    INC     C
    OUTI
    DEC     C
    INC     A
    CP      13
    JR      NZ,LOUT
    OUT     (C),A
    LD      A,(HL)
    AND     A
    RET     M
    INC     C
    OUT     (C),A
    RET

