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
    cp      7
    jr      nz,not_r7
    ld      d,a
    ld      a,(hl)
    cpl
    out     (c),a
    ld      a,d
    jr      continue
not_r7:
    OUTI
continue:
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

