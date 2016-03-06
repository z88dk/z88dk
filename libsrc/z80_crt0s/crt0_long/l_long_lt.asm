;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_lt
                EXTERN     l_long_cmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;

; DE < HL [signed]
.l_long_lt
        call    l_long_cmp
        ret     c
        dec     hl
        ret
