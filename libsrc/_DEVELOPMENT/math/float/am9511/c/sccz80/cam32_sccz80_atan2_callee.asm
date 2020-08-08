
SECTION code_fp_am9511
PUBLIC cam32_sccz80_atan2_callee

EXTERN _am9511_atan2f


.cam32_sccz80_atan2_callee
    pop hl      ; return
    pop bc      ; RHS
    pop de
    pop af      ; LHS
    ex (sp),hl  ; return to stack

    push de     ; RHS
    push bc    
    push hl     ; LHS
    push af

    call _am9511_atan2f
    pop af
    pop af
    pop af
    pop af
    ret
