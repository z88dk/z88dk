;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                XLIB    l_cm_bc
                LIB     l_bcneg



.l_cm_bc
        ld a,b
        or a
        ret p
        call    l_bcneg
        ret

