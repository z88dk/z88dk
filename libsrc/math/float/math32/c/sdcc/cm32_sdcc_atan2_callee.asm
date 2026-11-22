
SECTION code_fp_math32
PUBLIC cm32_sdcc_atan2_callee

EXTERN _m32_atan2f


cm32_sdcc_atan2_callee:
    pop hl      ; return
    pop bc      ; LHS
    pop de
    pop af      ; RHS
    ex (sp),hl  ; return to stack

    push hl     ; RHS
    push af
    push de     ; LHS
    push bc    

    call _m32_atan2f
    pop af
    pop af
    pop af
    pop af
    ret
