;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                XLIB    l_cm_de
                LIB     l_deneg


.l_cm_de
        ld a,d
        or a
        ret p
        call    l_deneg
        ret

