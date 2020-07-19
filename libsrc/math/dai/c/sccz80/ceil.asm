

        SECTION         code_fp_dai32

        PUBLIC          ceil
        EXTERN		l_long_neg
        EXTERN		l_f32_slong2f
        EXTERN		___dai32_setup_single
        EXTERN		___dai32_return
        EXTERN          ___dai32_fpac


ceil:
    call    ___dai32_setup_single
    ld      hl,___dai32_fpac+0
    ld      a,(hl)
    xor     $80
    ld      (hl),a
    push    af
;    call    ___dai32_FPINT 

    ; bcde = integer
    ; Now normalise it again
    ex      de,hl
    ld      e,c
    ld      d,b
    pop     af
    rlca
    jr      nc,not_negative
    dec     d
not_negative:
    call    l_long_neg
    jp      l_f32_slong2f
