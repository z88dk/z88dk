
        SECTION code_fp_math32
        PUBLIC  l_f32_swap

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
        ld      l,c
        ld      h,b     ; hl = left-LSW
        ret
