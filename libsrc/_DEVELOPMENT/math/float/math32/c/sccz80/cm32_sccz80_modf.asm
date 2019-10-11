
SECTION code_fp_math32

PUBLIC cm32_sccz80_modf

EXTERN _m32_modff

; float modff(float x, float * y)
.cm32_sccz80_modf
    ; Entry:
    ; Stack: float left, ptr right, ret

    ; Reverse the stack
    pop af      ;ret
    pop bc      ;ptr
    pop hl      ;float
    pop de
    push bc     ;ptr
    push de     ;float
    push hl
    push af     ;ret
    jp _m32_modff
