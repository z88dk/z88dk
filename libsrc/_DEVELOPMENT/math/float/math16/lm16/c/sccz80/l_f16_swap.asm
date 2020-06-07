
    SECTION code_fp_math16
    PUBLIC  l_f16_swap

; Entry: hl = right hand operand
; Stack: defw return address
;        defw left hand operand

.l_f16_swap
    pop bc          ; Return
    pop de          ; left
    push hl         ; Push right
    push bc         ; Return address
    ex de,hl
    ret
