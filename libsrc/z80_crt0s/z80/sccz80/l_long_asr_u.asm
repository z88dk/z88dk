;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;

        SECTION   code_crt0_sccz80
	PUBLIC    l_long_asr_u
 	PUBLIC    l_long_asr_uo

.l_long_asr_uo
        ld      a,c        
	jp	entry

.l_long_asr_u
	pop	bc	;Return address
        
        ld      a,l     ;temporary store for counter
        pop     hl
        pop     de
        push    bc
  
.entry 
        and	31
        ret     z
        
        ld b,a
        ld a,e          ; primary = dahl

.loop
        srl d
        rra
        rr h
        rr l
        djnz loop
        
        ld e,a
        ret
     
