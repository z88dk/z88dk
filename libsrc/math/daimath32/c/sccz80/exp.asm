
        SECTION code_fp_dai32

        PUBLIC  exp
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xexp
        EXTERN  ___dai32_return

exp:
        call    ___dai32_setup_single
        call    ___dai32_xexp
        jp      ___dai32_return
