

        SECTION code_fp_dai32

        PUBLIC  ceil
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_return
        EXTERN  ___dai32_xfix
        EXTERN  ___dai32_xflt
        EXTERN  ___dai32_fpac


ceil:
    call    ___dai32_setup_single
    ld      hl,___dai32_fpac
    ld      a,(hl)
    call    ___dai32_xfix           ;Turns fpac into integer, preserves registers
    rlca
    ; It's postive, we need to increment
    ld      hl,___dai32_fpac+3
    call    nc, inclong
    call    ___dai32_xflt
    jp      ___dai32_return


inclong:
    inc     (hl)
    ret     nz
    dec     hl
    inc     (hl)
    ret     nz
    dec     hl
    inc     (hl)
    ret     nz
    dec     hl
    inc     (hl)
    ret