;       Z88 Small C+ Run Time Library 
;       Long functions
;

                SECTION   code_crt0_sccz80
                PUBLIC    l_long_gt
                EXTERN     l_long_cmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; dehl (stack) > dehl (reg)
; if true, then the resulting number from l_long_cmp will be +ve

.l_long_gt  
        call    l_long_cmp
	jr	z,l_long_gt1
        ccf			;true
        ret     c
.l_long_gt1
        dec   hl
        ret
