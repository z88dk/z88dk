

        SECTION code_fp_dai32

        PUBLIC  ceil
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_return
        EXTERN  ___dai32_xfadd
        EXTERN  ___dai32_xfint
        EXTERN  ___dai32_fpac
        EXTERN  ___dai32_tempval

ceil:
        call    ___dai32_setup_single
        ld      a, (___dai32_fpac)
        rla
        call    ___dai32_xfint
        jp      c, ___dai32_return      ;Negative we don't need to anything else
        ld      hl, $0100               ; -1
        ld      de, $0000
        ld      (___dai32_tempval+0), hl
        ex      de, hl
        ld      (___dai32_tempval+2), hl
        ld      hl, ___dai32_tempval
        call    ___dai32_xfadd
        jp      ___dai32_return
