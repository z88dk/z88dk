;       Z88 Small C+ Run Time Library 
;       Long functions
;

                XLIB    l_long_neg
                LIB     l_long_com



; deHL = -deHL
.l_long_neg
        call    l_long_com    
        push    bc
        ld      bc,1
        add     hl,bc
        pop     bc
        ret     nc
        inc     de
        ret
