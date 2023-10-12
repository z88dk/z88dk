
        SECTION code_fp_dai32

        PUBLIC  acos
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xacos
        EXTERN  ___dai32_return

acos:
        call    ___dai32_setup_single
        call    ___dai32_xacos
        jp      ___dai32_return
