    SECTION   code_l_sccz80
    PUBLIC    l_i64_ge
    EXTERN    l_i64_cmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
.l_i64_ge
        call    l_i64_cmp
        ccf
        ret     c
        scf
        ret     z
        ccf
        dec     hl
        ret
