;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_and

;Logical routines for long functions    dehl
;first opr in alt set




; "and" deHL' and dehl into HLde'
.l_long_and   
        ld       a,d
        exx             ;primary
	pop	bc
	pop	hl
	pop	de
	push	bc
        and     d
        ld      d,a
        ld      a,e
        exx             ;2nd
        and     e
        exx             ;1st
        ld      e,a
        ld      a,h
        exx             ;2nd
        and     h
        exx             ;1st
        ld      h,a
        ld      a,l
        exx             ;2nd
        and     l
        exx             ;1st
        ld      l,a
        ret
