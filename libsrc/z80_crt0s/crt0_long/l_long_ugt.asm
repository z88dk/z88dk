;
;       Z88 Small C+ Run Time Library 
;       Long library functions
;

                XLIB    l_long_ugt
                LIB     l_long_ucmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; primary (stack) > secondary (dehl)

.l_long_ugt
        call    l_long_ucmp
        ccf
        ret     c
;        ret     nc
        dec     hl
        ret
