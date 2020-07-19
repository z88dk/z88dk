

        SECTION code_fp_dai32

        PUBLIC  floor
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_return
        EXTERN  ___dai32_xfix
        EXTERN  ___dai32_xflt
        EXTERN  ___dai32_fpac


floor:
    call    ___dai32_setup_single
    ld      hl,___dai32_fpac
    ld      a,(hl)
    call    ___dai32_xfix           ;Turns fpac into integer, preserves registers
    rlca
    ; It's negative, we need to decrement
    ld      hl,___dai32_fpac+3
    call    c, declong
    call    ___dai32_xflt
    jp      ___dai32_return


declong:
    dec     (hl)
    ret     nz
    dec     hl
    dec     (hl)
    ret     nz
    dec     hl
    dec     (hl)
    ret     nz
    dec     hl
    inc     (hl)
    ret
