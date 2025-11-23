                SECTION   code_l_sccz80
                PUBLIC    l_i64_ule
                EXTERN     l_i64_ucmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
.l_i64_ule
        call    l_i64_ucmp
        ret     c
        scf
        ret     z
        ccf
        dec     hl
        ret

