;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_ule
                LIB     l_long_ucmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE <= HL [unsigned]
.l_long_ule
        call    l_long_ucmp
        ret     c
        scf
        ret     z
        ccf
        dec     hl
        ret

