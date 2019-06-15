
SECTION code_fp_math32

PUBLIC cm32_sccz80_ldexp

EXTERN m32_fsldexp_callee

; float ldexpf(float x, int16_t pw2);

.cm32_sccz80_ldexp

    ; Entry:
    ; Stack: float left, int right, ret
    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;int
    pop hl                      ;float
    pop de
    push af                     ;my return
    push bc                     ;int
    push de                     ;float
    push hl
    call m32_fsldexp_callee

    pop af                      ;my return
    push af
    push af
    push af
    push af
    ret
