
        SECTION code_fp_dai32

        PUBLIC  atan
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xatan
        EXTERN  ___dai32_return

atan:
        call    ___dai32_setup_single
        call    ___dai32_xatan
        jp      ___dai32_return
