
        SECTION code_fp_dai32

        PUBLIC  l_f32_sub
        EXTERN  ___dai32_setup_arith
        EXTERN  ___dai32_xfsub
        EXTERN  ___dai32_return


l_f32_sub:
        call    ___dai32_setup_arith
        call    ___dai32_xfsub
        jp      ___dai32_return


