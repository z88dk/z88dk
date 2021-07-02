
SECTION code_fp_am9511
PUBLIC cam32_sdcc_atan2_callee

EXTERN _am9511_atan2

.cam32_sdcc_atan2_callee
    pop hl      ; return
    pop bc      ; LHS
    pop de
    pop af      ; RHS
    ex (sp),hl  ; return to stack

    push hl     ; RHS
    push af
    push de     ; LHS
    push bc    

    call _am9511_atan2
    pop af
    pop af
    pop af
    pop af
    ret
