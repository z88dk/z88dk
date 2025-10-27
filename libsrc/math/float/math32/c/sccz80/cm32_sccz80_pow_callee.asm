
SECTION code_fp_math32
PUBLIC cm32_sccz80_pow_callee

EXTERN _m32_powf


cm32_sccz80_pow_callee:
    pop hl      ; return
    pop bc      ; RHS
    pop de
    pop af      ; LHS
    ex (sp),hl  ; return to stack

    push de     ; RHS
    push bc
    push hl     ; LHS
    push af

    call _m32_powf
    pop af
    pop af
    pop af
    pop af
    ret
