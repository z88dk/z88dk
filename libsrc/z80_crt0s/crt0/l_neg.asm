;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                XLIB    l_neg
                LIB     l_com


; HL = -HL
.l_neg
        call    l_com    
        inc   hl
        ret


