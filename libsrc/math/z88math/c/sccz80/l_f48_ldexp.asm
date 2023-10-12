
        SECTION code_fp

        PUBLIC  l_f48_ldexp
        EXTERN  __ldexp_on_fa


l_f48_ldexp:
        ld      c, a
        jp      __ldexp_on_fa

