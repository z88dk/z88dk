
SECTION code_fp_math32

PUBLIC cm32_sccz80_frexp

EXTERN m32_fsfrexp_callee

; float frexpf(float x, int16_t *pw2);

.cm32_sccz80_frexp

    ; Entry:
    ; Stack: float left, ptr right, ret
    ; Reverse the stack
    pop af                      ;my return
    pop bc                      ;ptr
    pop hl                      ;float
    pop de
    push af                     ;my return
    push bc                     ;ptr
    push de                     ;float
    push hl
    call m32_fsfrexp_callee

    pop af                      ;my return
    push af
    push af
    push af
    push af
    ret
