; Vortextracker II player
;
; Hardware output routine for PHC-25
;
;

    SECTION code_psg

    PUBLIC  asm_vt_hardware_out
    PUBLIC  asm_vt_hardware_out_A0

    EXTERN  asm_VT_AYREGS


asm_vt_hardware_out:
    XOR     A
asm_vt_hardware_out_A0:
    LD      C, $C0
    LD      HL, asm_VT_AYREGS
LOUT:
    OUT     (C), A
    DEC     C
    OUTI
    INC     C
    INC     A
    CP      13
    JR      NZ, LOUT
    OUT     (C), A
    LD      A, (HL)
    AND     A
    RET     M
    INC     C
    OUT     (C), A
    RET

