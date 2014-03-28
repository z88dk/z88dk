;       Small C+ Z80 Run time library
;       The new case statement..maybe things will work now!
;       13/10/98

        XLIB    l_long_case


;Case statement for longs
;Enter with dehl=number to check against..


.l_long_case
        pop     ix              ;switch table
.swloop
	ld	a,(ix+0)
	or	(ix+1)
        inc     ix
        inc     ix
        jr      z,swend         ;enod of table
;Now, have to check our values
        ld      bc,4
        add     ix,bc           ;points to next entry,,
        ld      a,(ix-4)
        cp      l
        jr      nz,swloop
        ld      a,(ix-3)
        cp      h
        jr      nz,swloop
        ld      a,(ix-2)
        cp      e
        jr      nz,swloop
	ld	a,(ix-1)
        cp      d
        jr      nz,swloop
;Have had a match here...so, load up address, and get there
IF Z80S183
	ld	e,(ix-6)	;low byte
	ld	d,(ix-5)	;high
	push	de
	pop	ix
ELSE
        ld      a,(ix-6)        ;low byte
        ld      ixh,(ix-5)
        ld      ixl,a
ENDIF
.swend
        jp      (ix)
        
