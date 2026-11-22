
                SECTION   code_l_sccz80
                PUBLIC    l_i64_uge
                EXTERN     l_i64_ucmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;

; primary (stack) >= secondary (acc)

.l_i64_uge
        call    l_i64_ucmp
        ccf
        ret     c
        scf
        ret     z
;        ret     nc
        ccf
        dec     hl
        ret
