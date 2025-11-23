
                SECTION   code_l_sccz80
                PUBLIC    l_i64_gt
                EXTERN     l_i64_cmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; (stack) > (acc)
; if true, then the resulting number from l_i64_cmp will be +ve
.l_i64_gt  
        call    l_i64_cmp
	jr	z,l_i64_gt1
        ccf			;true
        ret     c
.l_i64_gt1
        dec   hl
        ret
