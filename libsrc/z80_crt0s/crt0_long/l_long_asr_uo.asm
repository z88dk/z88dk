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

                XLIB    l_long_asr_uo



; Shift primary (on stack) right by secondary, 
; We can only shift a maximum of 32 bits (or so), so the counter can
; go in c

.l_long_asr_uo
        dec     c
        ret     m       ;counter has flipped to 255
        and     a
        rr      d
        rr      e
        rr      h
        rr      l
        jr      l_long_asr_uo

