;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;       djm 25/2/99
;       Made work! - Seems a little messed up previously (still untested)
;
;       djm 7/5/99
;       This version is called when the optimizer has had a look at
;       the code

                XLIB    l_long_aslo


; Shift primary left by secondary
;
; Primary is on the stack, and is 32 bits long therefore we need only
; concern ourselves with l (secondary) as our counter
;
; For optimized version we enter with the word in dehl and the shift
; counter in a

.l_long_aslo
.l_long_aslo1
        dec     a
        ret     m       ;flipped down to 255
        add     hl,hl   ;double lower 16
        ex      de,hl
        adc     hl,hl   ;double upper 16 (taking into a/c carry from prev)
        ex      de,hl
        jr      l_long_aslo1

