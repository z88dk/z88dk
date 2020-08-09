
SECTION code_fp_am9511

PUBLIC asm_am9511_fmod_callee

EXTERN _am9511_fmod

.asm_am9511_fmod_callee
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
    call _am9511_fmod
    pop af
    pop af
    pop af
    pop af
    ret
