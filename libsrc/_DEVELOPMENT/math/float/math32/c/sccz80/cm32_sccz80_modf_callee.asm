
SECTION code_fp_math32

PUBLIC cm32_sccz80_modf_callee

EXTERN _m32_modff

; float modff(float x, float * y)
.cm32_sccz80_modf_callee
    ; Entry:
    ; Stack: float left, ptr right, ret

    ; Reverse the stack
    pop af      ;ret
    pop bc      ;ptr
    pop hl      ;float
    pop de
    push af     ;ret
    push bc     ;ptr
    push de     ;float
    push hl
    call _m32_modff
    pop af
    pop af
    pop af
    ret
