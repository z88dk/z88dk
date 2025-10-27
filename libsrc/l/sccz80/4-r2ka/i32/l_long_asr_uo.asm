;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       djm 22/3/99 Unsigned version
;
;       djm 7/5/99 Optimizer version, enter with dehl = long c=counter
;
;       aralbrec 01/2007 Sped up, would be better with a or b = counter

SECTION code_clib
SECTION code_l_sccz80
PUBLIC l_long_asr_uo

; Shift primary (on stack) right by secondary, 
; We can only shift a maximum of 32 bits (or so), so the counter can
; go in c

; it's better to have the counter in a, maybe something to change in compiler

.l_long_asr_uo

        ld a,c
        and	31
        ret z
        
        ld b,a
.loop
	and	a
	rr	de
	rr	hl
        djnz loop
        ret
