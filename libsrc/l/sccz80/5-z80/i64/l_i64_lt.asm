                SECTION   code_l_sccz80
                PUBLIC    l_i64_lt
                EXTERN     l_i64_cmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
.l_i64_lt
        call    l_i64_cmp
        ret     c
        dec     hl
        ret
