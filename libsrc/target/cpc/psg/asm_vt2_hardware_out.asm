; VT2 player
;
; Hardware output routine for CPC
;
;

	SECTION	code_psg

        PUBLIC  asm_vt_hardware_out
        PUBLIC  asm_vt_hardware_out_A0
        EXTERN  asm_VT_AYREGS


asm_vt_hardware_out:
        XOR A
asm_vt_hardware_out_A0:
 LD HL,asm_VT_AYREGS
LOUT:
 CALL WRITEPSGHL
 INC A
 CP 13
 JR NZ,LOUT
 LD A,(HL)
 AND A
 RET M
 LD A,13
 CALL WRITEPSGHL
 RET

;; A = REGISTER
;; (HL) = VALUE
WRITEPSGHL:
 LD B,$F4
 OUT (C),A
 LD BC,$F6C0
 OUT (C),C
 DEFB $ED	;out (c),0
 DEFB $71
 LD B,$F5
 OUTI
 LD BC,$F680
 OUT (C),C
 DEFB $ED
 DEFB $71
 RET
