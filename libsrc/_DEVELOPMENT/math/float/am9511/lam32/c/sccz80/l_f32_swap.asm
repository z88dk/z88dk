
SECTION code_clib
SECTION code_fp_am9511

PUBLIC  l_f32_swap

IFDEF __CPU_8085__

EXTERN  asm_switch_arg

; Entry: dehl = right hand operand
; Stack: defw return address
;        defw left hand LSW
;        defw left hand MSW
.l_f32_swap
    pop bc
    push de
    push hl
    push bc

    call asm_switch_arg

    pop bc
    pop hl
    pop de
    push bc

    ret

ELSE

; Entry: dehl = right hand operand
; Stack: defw return address
;        defw left hand LSW
;        defw left hand MSW
.l_f32_swap
        pop     af      ; Return
        pop     bc      ; left-LSW
        ex      de,hl   ; de = right-LSW, hl = right-MSW
        ex      (sp),hl ; hl = left-MSW, (sp) = right-MSW
        push    de      ; Push right-LSW
        push    af      ; Return address
        ex      de,hl   ; de = left-MSW
        ld      hl,bc   ; hl = left-LSW
        ret

ENDIF
