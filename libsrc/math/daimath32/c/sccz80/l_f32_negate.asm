

        SECTION code_fp_dai32

        PUBLIC  l_f32_negate

l_f32_negate:
        ld      a, d
        and     127
        ret     z
        ld      a, d
        xor     $80
        ld      d, a
        ret
