

        SECTION code_fp_dai32

        PUBLIC  floor
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_return
        EXTERN  ___dai32_xfadd
        EXTERN  ___dai32_xfint
        EXTERN  ___dai32_fpac
        EXTERN  ___dai32_tempval


floor:
        call    ___dai32_setup_single
        ld      a, (___dai32_fpac)
        rla
        call    ___dai32_xfint
        jp      nc, ___dai32_return     ;Positive we don't need to anything else
        ld      hl, $8100               ; -1
        ld      de, $0000
        ld      (___dai32_tempval+0), hl
        ex      de, hl
        ld      (___dai32_tempval+2), hl
        ld      hl, ___dai32_tempval
        call    ___dai32_xfadd
        jp      ___dai32_return
