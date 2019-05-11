;
;       Z88dk Z88 Maths Library
;
;
;       $Id: stkequcmp.asm,v 1.3 2016-06-22 19:55:06 dom Exp $

                SECTION  code_fp
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
