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
	PUBLIC    l_long_asr
	PUBLIC    l_long_asro

.l_long_asro
	ld	a,c
	jp	entry

; Shift primary (on stack) right by secondary, 
; We can only shift a maximum of 32 bits (or so), so the counter can
; go in c

.l_long_asr
	pop	bc
        ld      a,l     ;temporary store for counter
        pop     hl
        pop     de
	push	bc

.entry
	and	31
	ret	z
        ld b,a
        ld a,e          ; primary = dahl
.loop

        sra d
        rra
        rr h
        rr l
        djnz loop
        
        ld e,a
	ret
