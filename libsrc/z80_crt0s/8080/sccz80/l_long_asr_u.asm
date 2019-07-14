;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       aralbrec 01/2007
;       sped up some more


                SECTION   code_crt0_sccz80
		PUBLIC    l_long_asr_u

; Shift primary (on stack) right by secondary, 
; We can only shift a maximum of 32 bits (or so), so the counter can
; go in c

.l_long_asr_u

        pop	bc
   
        ld      a,l     ;temporary store for counter
        pop     hl
        pop     de
	push	bc
        
	and	31
	ret	z
        
        ld	b,a
.loop
	and	a
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
.done
	ret
