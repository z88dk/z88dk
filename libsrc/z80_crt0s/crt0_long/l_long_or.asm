;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_or

;Logical routines for long functions    dehl
;first opr on stack


; "or" deHL' and dehl into HLde'
.l_long_or   
        ld       a,d
        exx             ;primary
	pop	bc
	pop	hl
	pop	de
	push	bc
        or      d
        ld      d,a
        ld      a,e
        exx             ;2nd
        or      e
        exx             ;1st
        ld      e,a
        ld      a,h
        exx             ;2nd
        or      h
        exx             ;1st
        ld      h,a
        ld      a,l
        exx             ;2nd
        or      l
        exx             ;1st
        ld      l,a
        ret

