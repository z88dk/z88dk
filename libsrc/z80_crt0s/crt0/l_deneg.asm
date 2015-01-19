;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                PUBLIC    l_deneg

; {DE = -DE}
.l_deneg 
        ld  a,d
        cpl
        ld d,a
        ld a,e
        cpl
        ld e,a
        inc   de
        ret
