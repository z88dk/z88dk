
        SECTION code_fp_dai32

        PUBLIC  sqrt
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xsqrt
        EXTERN  ___dai32_return

sqrt:
        call    ___dai32_setup_single
        call    ___dai32_xsqrt
        jp      ___dai32_return
