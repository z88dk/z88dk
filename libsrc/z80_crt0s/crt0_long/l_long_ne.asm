;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_ne
                LIB     l_long_cmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DEhl' != deHL
.l_long_ne
        call    l_long_cmp
        scf
        ret   nz
        ccf
        dec   hl
        ret
