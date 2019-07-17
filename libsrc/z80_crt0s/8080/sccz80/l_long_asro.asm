;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       djm 7/6/99
;       The optimizer version! Entered with long in dehl and counter in c
;
;       aralbrec 01/2007
;       Sped up, would be better with counter in a or b

                SECTION   code_crt0_sccz80
PUBLIC    l_long_asro

; Shift primary (on stack) right by secondary, 
; We can only shift a maximum of 32 bits (or so), so the counter can
; go in c

.l_long_asro

        ld a,c
        and	31
        ret z
        
        ld b,a
.loop
	ld	a,d
	rla
	ld	a,d
	rra
	ld	d,a
	ld	a,e
	rra	
	ld	e,a
	ld	a,h
	rra
	ld	h,a
	ld	a,l
	rra
	ld	l,a
	dec	b
	jp	nz,loop
        ret
