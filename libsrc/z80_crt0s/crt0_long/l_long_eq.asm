;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_eq
                LIB     l_long_cmp




;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; dehl' == deHL
.l_long_eq
        call    l_long_cmp
        scf
        ret   z
	dec	hl
	and	a
        ret
