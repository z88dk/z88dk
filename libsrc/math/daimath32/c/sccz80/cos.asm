
        SECTION code_fp_dai32

        PUBLIC  cos
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xcos
        EXTERN  ___dai32_return

cos:
        call    ___dai32_setup_single
        call    ___dai32_xcos
        jp      ___dai32_return
