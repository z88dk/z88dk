;
;       Z88dk Z88 Maths Library
;
;
;       $Id: stkequcmp.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $


		PUBLIC	stkequcmp

.stkequcmp
        pop     de      ;return address
        pop     bc      ;dump number..
        pop     bc
        pop     bc
        push    de      ;put it back
        ld      a,h
        or      l       ;sets nc
        ret     z       
        ld      hl,1
        scf
        ret
