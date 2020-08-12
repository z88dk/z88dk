;
;       Z88 Small C+ Run Time Library 
;       Long library functions
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_ugt
                EXTERN     l_long_ucmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; primary (stack) > secondary (dehl)

.l_long_ugt
        call    l_long_ucmp
	jr	z,l_long_ugt1
        ccf
        ret     c
;        ret     nc
.l_long_ugt1
        dec     hl
        ret
