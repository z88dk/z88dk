                SECTION   code_l_sccz80
                PUBLIC    l_i64_ugt
                EXTERN     l_i64_ucmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; primary (stack) > secondary (acc)

.l_i64_ugt
        call    l_i64_ucmp
	jr	z,l_i64_ugt1
        ccf
        ret     c
;        ret     nc
.l_i64_ugt1
        dec     hl
        ret
