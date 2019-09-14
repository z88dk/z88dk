
SECTION code_fp_math32

PUBLIC cm32_sccz80_fmod

EXTERN _m32_fmodf

.cm32_sccz80_fmod
    ; Entry:
    ; Stack: float left, float right, ret
    ; Reverse the stack
    pop hl      ;ret
    pop af      ;right
    pop bc
    pop de      ;left
    ex (sp),hl  ;ret
    push bc     ;right
    push af
    push hl     ;left
    push de
    call _m32_fmodf
    pop af
    pop af
    pop af
    pop af
    ret
