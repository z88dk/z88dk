;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_ult
                EXTERN     l_long_ucmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE < HL [unsigned]
.l_long_ult
        call    l_long_ucmp
        ret     c
        dec     hl
        ret




