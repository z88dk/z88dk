;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                PUBLIC    l_com


; HL = ~HL
.l_com 
        ld a,h
        cpl
        ld h,a
        ld a,l
        cpl
        ld l,a
        ret

