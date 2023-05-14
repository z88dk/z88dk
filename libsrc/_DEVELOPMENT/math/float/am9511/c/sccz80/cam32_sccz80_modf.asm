
SECTION code_fp_am9511

PUBLIC cam32_sccz80_modf

EXTERN _am9511_modf

; float modf(float x, float * y)
.cam32_sccz80_modf
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
    jp _am9511_modf
