;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_ge
                EXTERN     l_long_cmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE >= HL [signed]
.l_long_ge
        call    l_long_cmp
        ccf
        ret     c
;        ret     nc
        scf
        ret     z
        ccf
        dec     hl
        ret
