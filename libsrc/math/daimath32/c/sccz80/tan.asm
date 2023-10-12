
        SECTION code_fp_dai32

        PUBLIC  tan
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xtan
        EXTERN  ___dai32_return

tan:
        call    ___dai32_setup_single
        call    ___dai32_xtan
        jp      ___dai32_return
