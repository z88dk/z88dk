;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_uge
                EXTERN     l_long_ucmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;

; primary (stack) >= secondary (dehl)

.l_long_uge
        call    l_long_ucmp
        ccf
        ret     c
        scf
        ret     z
;        ret     nc
        ccf
        dec     hl
        ret
