
SECTION code_fp_math32
PUBLIC cm32_sdcc_pow_callee

EXTERN _m32_powf


cm32_sdcc_pow_callee:
    pop hl      ; return
    pop bc      ; LHS
    pop de
    pop af      ; RHS
    ex (sp),hl  ; return to stack

    push hl     ; RHS
    push af
    push de     ; LHS
    push bc

    call _m32_powf
    pop af
    pop af
    pop af
    pop af
    ret
