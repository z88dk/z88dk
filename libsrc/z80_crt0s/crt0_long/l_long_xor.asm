;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_xor

;Logical routines for long functions    dehl
;first opr on stack


; "xor" deHL' and dehl into HLde'
.l_long_xor   
        ld       a,d
        exx             ;primary
	pop	bc
	pop	hl
	pop	de
	push	bc
        xor      d
        ld      d,a
        ld      a,e
        exx             ;2nd
        xor      e
        exx             ;1st
        ld      e,a
        ld      a,h
        exx             ;2nd
        xor      h
        exx             ;1st
        ld      h,a
        ld      a,l
        exx             ;2nd
        xor      l
        exx             ;1st
        ld      l,a
        ret
