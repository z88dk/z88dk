
SECTION code_fp_am9511

PUBLIC cam32_sccz80_modf_callee

EXTERN _am9511_modf

; float modff(float x, float * y)
.cam32_sccz80_modf_callee
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
    call _am9511_modf
    pop af
    pop af
    pop af
    ret
