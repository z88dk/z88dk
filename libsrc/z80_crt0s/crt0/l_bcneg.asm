;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                PUBLIC    l_bcneg



; {BC = -BC}
.l_bcneg 
        ld  a,b
        cpl
        ld b,a
        ld a,c
        cpl
        ld c,a
        inc   bc
        ret


