
    SECTION code_fp_math16
    PUBLIC  l_f16_swap

; Entry: hl = right hand operand
; Stack: defw return address
;        defw left hand operand

.l_f16_swap
    pop bc          ; Return
    ex (sp),hl      ; Exchange left for right
    push bc         ; Return address
    ret
