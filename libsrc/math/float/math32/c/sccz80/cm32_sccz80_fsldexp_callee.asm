
SECTION code_fp_math32

PUBLIC cm32_sccz80_ldexp_callee

EXTERN m32_fsldexp_callee

; float ldexpf(float x, int16_t pw2);

.cm32_sccz80_ldexp_callee
    ; Entry:
    ; Stack: float left, int right, ret

    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;int
    pop hl                      ;float
    pop de
    push bc                     ;int
    push de                     ;float
    push hl
    push af                     ;my return
    jp m32_fsldexp_callee
    
