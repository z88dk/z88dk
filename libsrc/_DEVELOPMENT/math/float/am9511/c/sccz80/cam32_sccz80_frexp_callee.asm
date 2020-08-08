
SECTION code_fp_math32

PUBLIC cm32_sccz80_frexp_callee

EXTERN m32_fsfrexp_callee

; float frexpf(float x, int16_t *pw2);
.cm32_sccz80_frexp_callee
    ; Entry:
    ; Stack: float left, ptr right, ret

    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;ptr
    pop hl                      ;float
    pop de
    push bc                     ;ptr
    push de                     ;float
    push hl
    push af                     ;my return
    jp  m32_fsfrexp_callee
