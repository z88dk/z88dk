;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       djm 7/6/99
;       The optimizer version! Entered with long in dehl and counter in c

                XLIB    l_long_asro



; Shift primary (on stack) right by secondary, 
; We can only shift a maximum of 32 bits (or so), so the counter can
; go in c

.l_long_asro
        dec     c
        ret     m       ;counter has flipped to 255
;Preserve sign
        ld      a,d
        rla
        rr      d
        rr      e
        rr      h
        rr      l
        jr      l_long_asro

